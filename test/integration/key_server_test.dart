import 'dart:math';

import 'package:dart_sdk/api/tfa/model/tfa_factor.dart';
import 'package:dart_sdk/api/tokend_api.dart';
import 'package:dart_sdk/key_server/key_server.dart';
import 'package:dart_sdk/key_server/models/signer_data.dart';
import 'package:dart_sdk/key_server/models/wallet_create_result.dart';
import 'package:dart_sdk/key_server/models/wallet_info.dart';
import 'package:dart_sdk/tfa/exceptions.dart';
import 'package:dart_sdk/tfa/password_tfa_otp_generator.dart';
import 'package:dart_sdk/tfa/tfa_callback.dart';
import 'package:dart_sdk/tfa/tfa_verifier.dart';
import 'package:dart_wallet/account.dart';
import 'package:dart_wallet/network_params.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util.dart';

void main() {
  test('sign up simple', () async {
    var email =
        'signUpTest${Random.secure().nextInt(Int32.MAX_VALUE.toInt())}@gmail.com';
    var password = 'qwe123';

    var api = Util.getApi();

    var keyServer = KeyServer(api.wallets);

    print("Attempt to sign up $email $password");

    var rootAccount = await Account.random();
    var result = await keyServer.createAndSaveWallet(
        email, password, api.v3.keyValue, rootAccount);

    print("Account ID is ${result.rootAccount.accountId}");

    await checkSignUpResult(email, password, result, api);
  });

  test('sign up with signers', () async {
    var email =
        'signUpWithSignersTest${Random.secure().nextInt(Int32.MAX_VALUE.toInt())}@gmail.com';
    var password = 'qwe123';

    var rootAccount = await Account.random();
    var api = Util.getApi();

    var keyServer = KeyServer(api.wallets);

    var signerRole = (await api.v3.keyValue
        .getById(KeyServer.DEFAULT_SIGNER_ROLE_KEY_VALUE_KEY))['value']['u32'];

    var randomSigners = <Account>[];
    for (int i = 0; i < 4; i++) {
      var newRandomSigner = await Account.random();
      randomSigners.add(newRandomSigner);
    }
    var signerAccounts = List.of([rootAccount]);
    signerAccounts.addAll(randomSigners);

    var signers = signerAccounts
        .map((signer) => SignerData(signer.accountId, signerRole));

    print("Attempt to sign up $email $password");

    var result = await keyServer.createAndSaveWalletWithSigners(
        email, password, rootAccount, signers);

    print("Account ID is ${result.rootAccount.accountId}");

    expect(
      rootAccount.secretSeed,
      result.rootAccount.secretSeed,
      reason: "Result account must be equal to the provided one",
    );

    await checkSignUpResult(email, password, result, api);

    var actualSigners = (await api.v3.signers
        .get(result.walletData.attributes.accountId))['data'];

    var allSignersHaveRole = true;
    actualSigners.forEach((signer) {
      if (signer['relationships']['role']['data']['id'] !=
          signerRole.toString()) {
        allSignersHaveRole = false;
      }
    });

    expect(
      allSignersHaveRole,
      true,
      reason: "All signers must have specified role $signerRole",
    );
  });

  test('sign in', () async {
    var email = 'testuser@gmail.com';
    var password = 'testuser@gmail.com';

    var api = Util.getApi();

    var keyServer = KeyServer(api.wallets);

    print("Attempt to sign up $email $password");

    var walletInfo = await keyServer.getWalletInfo(email, password);

    print(walletInfo.secretSeeds.first);
  });

  test('password change', () async {
    var email = 'passwordChangeTest@gmail.com';
    var password = 'testuser@gmail.com';

    var api = Util.getApi();

    var keyServer = KeyServer(api.wallets);

    print("Attempt to sign up $email $password");
    var rootAccount = await Account.random();

    var walletInfo = await keyServer.createAndSaveWallet(
        email, password, api.v3.keyValue, rootAccount);
    email = walletInfo.walletData.attributes.email;

    var currentWalletInfo = await keyServer.getWalletInfo(email, password);

    var tfaCallback = _AnonymousTfaCallback(email, password);

    var signedApi = Util.getSignedApi(rootAccount, tfaCallback: tfaCallback);

    var newPassword = 'qweqwe';
    var newAccount = await Account.random();

    var signedKeyServer = KeyServer(signedApi.wallets);

    var newWalletInfo = await signedKeyServer.updateWalletPassword(
        currentWalletInfo,
        rootAccount,
        newPassword,
        newAccount,
        NetworkParams('passphrase'),
        //TODO add system info
        api.v3.signers,
        api.v3.keyValue);

    WalletInfo remoteNewWalletInfo;
    try {
      remoteNewWalletInfo = await keyServer.getWalletInfo(email, newPassword);
    } catch (e) {
      print('New wallet must be accessible with new credentials');
      throw e;
    }

    expect(newWalletInfo, remoteNewWalletInfo,
        reason:
            'Updated info from the key server must be equal to the returned one');
    expect(walletInfo.walletData.id, newWalletInfo.walletIdHex,
        reason: 'Wallet ID must be changed after password change');
    expect(currentWalletInfo.loginParams.kdfAttributes.salt,
        remoteNewWalletInfo.loginParams.kdfAttributes.salt,
        reason: 'Wallet KDF salt must be changed after password change');
    expect(rootAccount.accountId, newWalletInfo.accountId,
        reason: 'Wallet account ID must be unchanged after password change');
    expect(
        newWalletInfo.secretSeeds.first, remoteNewWalletInfo.secretSeeds.first,
        reason: 'Wallet new secret seed must be equal to the required one');

    var signers =
        (await api.v3.signers.get(currentWalletInfo.accountId))['data'];
    var containsNewSigner = false;
    signers.forEach((signer) {
      if (signer['id'] == newAccount.accountId) containsNewSigner = true;
    });
    var containsOldSigner = false;
    signers.forEach((signer) {
      if (signer['id'] == rootAccount.accountId) containsOldSigner = true;
    });

    expect(containsNewSigner, true,
        reason:
            'A new signer ${newAccount.accountId} must be added to account signers');

    expect(containsOldSigner, true,
        reason:
            'The old signer ${rootAccount.accountId} must be removed from account signers');
  });
}

class _AnonymousTfaCallback extends TfaCallback {
  String email;
  String password;

  _AnonymousTfaCallback(this.email, this.password);

  @override
  Future<void> onTfaRequired(
      NeedTfaException exception, Interface verifierInterface) async {
    if (exception.factorType == TfaFactorType.PASSWORD) {
      verifierInterface.verify(
          await PasswordTfaOtpGenerator().generate(exception, email, password));
    }
  }
}

checkSignUpResult(String email, String password, WalletCreateResult result,
    TokenDApi api) async {
  var keyServer = KeyServer(api.wallets);

  expect(
    result.rootAccount.accountId,
    result.walletData.attributes.accountId,
    reason: "Account ID in wallet data must be equal to the root account ID",
  );
  expect(
    email.toLowerCase() == email,
    false,
    reason: "Email for sign up test must contain upper case characters",
  );
  expect(
    email.toLowerCase() == result.walletData.attributes.email,
    true,
    reason: "Email in wallet data must be lowercased",
  );

  WalletInfo walletInfo;
  try {
    walletInfo = await keyServer.getWalletInfo(email, password);
  } catch (e) {
    throw e;
  }

  expect(
    result.walletData.id,
    walletInfo.walletIdHex,
    reason:
        "Wallet ID obtained from the key server must be equal to the sent one",
  );

  WalletInfo recoveryWalletInfo;
  try {
    recoveryWalletInfo =
        await keyServer.getWalletInfo(email, password, isRecovery: true);
  } catch (e) {
    throw e;
  }

  expect(
    result.rootAccount.accountId,
    recoveryWalletInfo.accountId,
    reason: "Recovery wallet account ID must be equal to the original one",
  );

  var walletSigners = (await api.v3.signers.get(walletInfo.accountId))['data'];

  var containsSigner = false;
  walletSigners.forEach((signer) {
    if (signer['id'] == walletInfo.accountId) containsSigner = true;
  });

  expect(
    containsSigner,
    true,
    reason: 'There must be a signer for wallet root account',
  );
}
