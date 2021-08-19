import 'package:dart_sdk/api/v3/keyvalue/key_value_storage_api_v3.dart';
import 'package:dart_sdk/api/v3/signers/signers_api_v3.dart';
import 'package:dart_sdk/api/wallets/wallets_api.dart';
import 'package:dart_sdk/key_server/models/login_params.dart';
import 'package:dart_sdk/key_server/models/signer_data.dart';
import 'package:dart_sdk/key_server/models/wallet_create_result.dart';
import 'package:dart_sdk/key_server/models/wallet_data.dart';
import 'package:dart_sdk/key_server/models/wallet_info.dart';
import 'package:dart_sdk/key_server/models/wallet_relation.dart';
import 'package:dart_sdk/key_server/wallet_encryption.dart';
import 'package:dart_sdk/key_server/wallet_key_derivation.dart';
import 'package:dart_wallet/account.dart';
import 'package:dart_wallet/network_params.dart';
import 'package:dart_wallet/public_key_factory.dart';
import 'package:dart_wallet/transaction.dart' as Transaction;
import 'package:dart_wallet/transaction_builder.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:dio/dio.dart';

class KeyServer {
  WalletsApi walletsApi;

  KeyServer(this.walletsApi);

  // region Obtain
  /// Loads user's wallet and decrypts secret seed.
  /// See buildWalletInfo
  Future<WalletInfo> getWalletInfo(String login, String password,
      {bool isRecovery = false, Map<String, dynamic>? queryMap}) {
    return buildWalletInfo(login, password);
  }

  /// See [getLoginParams]
  /// See [getWalletData]
  Future<WalletInfo> buildWalletInfo(String login, String password,
      {bool isRecovery = false, Map<String, dynamic>? queryMap}) async {
    var loginParams =
        await getLoginParams(login: login, isRecovery: isRecovery);
    var derivationLogin = login.toLowerCase();

    var hexWalletId = WalletKeyDerivation.deriveAndEncodeWalletId(
        derivationLogin, password, loginParams.kdfAttributes);
    var walletKey = WalletKeyDerivation.deriveWalletEncryptionKey(
        derivationLogin, password, loginParams.kdfAttributes);

    var walletData = await getWalletData(hexWalletId, queryMap: queryMap);

    var keychainData = walletData.attributes.keychainData;
    var accountId = walletData.attributes.accountId;
    var email = walletData.attributes.email;

    if (isRecovery) {
      return WalletInfo(
        accountId,
        email,
        hexWalletId,
        loginParams,
        List.of([password]),
      );
    } else {
      return WalletInfo(
        accountId,
        email,
        hexWalletId,
        loginParams,
        WalletEncryption.decryptSecretSeeds(keychainData, walletKey),
      );
    }
  }

  /// Loads wallet by wallet ID.
  Future<WalletData> getWalletData(String walletId,
      {Map<String, dynamic>? queryMap}) {
    return walletsApi.getById(walletId, queryMap: queryMap ?? Map());
  }

  /// Loads KDF params.
  /// If no [login] specified will return default [LoginParams] without [KdfAttributes.salt]
  Future<LoginParams> getLoginParams({String? login, bool isRecovery = false}) {
    return walletsApi.getLoginParams(login, isRecovery);
  }

// endregion

  //region Save
  /// Submits given wallet to the system.
  Future<WalletData> saveWallet(WalletData walletData) {
    return walletsApi.create(walletData);
  }

  Future<void> updateWallet(String walletId, WalletData walletData) {
    return walletsApi.update(walletId, walletData);
  }

  //endregion

  //region Create and Save wallet
  /// Loads default login params, loads default signer role,
  /// creates a wallet with single signer and submits it to the system.
  Future<WalletCreateResult> createAndSaveWallet(String email, String password,
      KeyValueStorageApiV3 keyValueApi, Account rootAccount,
      {String? verificationCode}) async {
    var defaultSignerRole = await getDefaultSignerRole(keyValueApi);
    return _getCreateAndSaveWalletResult(
        email,
        password,
        List.of([rootAccount]),
        List.of([SignerData(rootAccount.accountId, defaultSignerRole)]));
  }

  /// Loads default login params, loads default signer role,
  /// creates a wallet with single signer and submits it to the system.
  Future<WalletCreateResult> createAndSaveWalletWithSigners(String email,
      String password, Account rootAccount, Iterable<SignerData> signers,
      {String? verificationCode}) async {
    return _getCreateAndSaveWalletResult(
      email,
      password,
      List.of([rootAccount]),
      signers,
      verificationCode: verificationCode,
    );
  }

  /// See [createWallet]
  /// See [saveWallet]
  /// See [getLoginParams]
  Future<WalletCreateResult> _getCreateAndSaveWalletResult(String email,
      String password, List<Account> accounts, Iterable<SignerData> signers,
      {String? verificationCode}) async {
    var loginParams = await getLoginParams();

    var kdf = loginParams.kdfAttributes;
    var kdfVersion = (loginParams.id);

    WalletCreateResult result = await createWallet(
        email, password, kdf, kdfVersion, accounts, signers,
        verificationCode: verificationCode);
    WalletData remoteWalletData = await saveWallet(result.walletData);

    return WalletCreateResult(remoteWalletData, result.rootAccount,
        result.walletId, result.loginParams, result.accounts);
  }

//endregion

  //region Update password
  Future<WalletInfo> updateWalletPassword(
      WalletInfo walletInfo,
      Account currentAccount,
      String newPassword,
      Account newAccount,
      NetworkParams networkParams,
      SignersApiV3 signersApi,
      KeyValueStorageApiV3 keyValueApi) {
    return _getUpdateWalletPasswordResult(walletInfo, currentAccount,
        newPassword, newAccount, networkParams, signersApi, keyValueApi);
  }

  Future<WalletInfo> _getUpdateWalletPasswordResult(
      WalletInfo walletInfo,
      Account currentAccount,
      String newPassword,
      Account newAccount,
      NetworkParams networkParams,
      SignersApiV3 signersApi,
      KeyValueStorageApiV3 keyValueApi) async {
    List<SignerData> signers;
    try {
      signers = await signersApi.get(walletInfo.accountId).then((signers) {
        var signersList = signers['data'] as List<Map<String, dynamic>>;
        return signersList
            .map((signer) => SignerData.fromJson(signer))
            .toList();
      });
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        signers = List.empty();
      } else {
        throw e;
      }
    }

    var defaultSignerRole = await getDefaultSignerRole(keyValueApi);
    SignerData currentAccountSigner =
        SignerData(currentAccount.accountId, defaultSignerRole);
    signers.forEach((signer) {
      if (signer.id == currentAccount.accountId) {
        currentAccountSigner = signer;
        return;
      }
    });

    return _getCurrentWalletUpdatePasswordResult(
        walletInfo,
        currentAccount,
        newPassword,
        List.of([newAccount]),
        networkParams,
        signers,
        List.of([
          SignerData.primary(
              newAccount.accountId,
              currentAccountSigner.identity,
              currentAccountSigner.weight,
              currentAccountSigner.roleId,
              currentAccountSigner.detailsJson)
        ]));
  }

  Future<WalletInfo> _getCurrentWalletUpdatePasswordResult(
      WalletInfo walletInfo,
      Account currentAccount,
      String newPassword,
      List<Account> newAccounts,
      NetworkParams networkParams,
      List<SignerData> currentSigners,
      Iterable<SignerData> newSigners) async {
    List<String> filteredSignersToRemoveIds = currentSigners
        .where((signer) => signer.roleId != RECOVERY_SIGNER_ROLE_ID)
        .map((signer) => signer.id)
        .toList();
    var signersUpdateTx = createSignersUpdateTransaction(
        networkParams,
        currentAccount,
        walletInfo.accountId,
        newSigners,
        filteredSignersToRemoveIds);

    var oldLoginParams = walletInfo.loginParams;
    var oldKdfAttributes = walletInfo.loginParams.kdfAttributes;
    var kdfAttributes = new KdfAttributes(
        oldKdfAttributes.algorithm,
        oldKdfAttributes.bits,
        oldKdfAttributes.n,
        oldKdfAttributes.p,
        oldKdfAttributes.r,
        oldKdfAttributes.encodedSalt);
    var newLoginParams =
        new LoginParams(oldLoginParams.type, oldLoginParams.id, kdfAttributes);

    // New KDF salt should be generated.
    newLoginParams.kdfAttributes.setSalt = null;

    var newWallet = await createWallet(
        walletInfo.email,
        newPassword,
        newLoginParams.kdfAttributes,
        (newLoginParams.id),
        newAccounts,
        List.empty());

    newLoginParams.kdfAttributes.encodedSalt =
        newWallet.walletData.attributes.salt;
    newWallet.walletData.addRelation(
        'transaction', WalletRelation.transaction(signersUpdateTx));

    await updateWallet(walletInfo.walletIdHex, newWallet.walletData);

    return WalletInfo(
        walletInfo.accountId,
        walletInfo.email,
        newWallet.walletData.id!,
        newLoginParams,
        newAccounts
            .map((account) => account.secretSeed)
            .where((seed) => seed != null)
            .toList() as List<String>);
  }

  //endregion

  //region Recovery

  /// Updates wallet with new password according to the KYC recovery flow.
  /// Temp signer will be added in order to request KYC recovery after
  /// sign in with new credentials.
  ///
  /// This requires email TFA confirmation.
  Future<WalletCreateResult> getRecoverWalletPasswordResult(
      String email, String password, List<Account> newAccounts) async {
    var currentLoginParams =
        await getLoginParams(login: email, isRecovery: true);
    var oldKdfAttributes = currentLoginParams.kdfAttributes;
    var kdfAttributes = new KdfAttributes(
        oldKdfAttributes.algorithm,
        oldKdfAttributes.bits,
        oldKdfAttributes.n,
        oldKdfAttributes.p,
        oldKdfAttributes.r,
        oldKdfAttributes.encodedSalt);
    var newLoginParams = new LoginParams(
        currentLoginParams.type, currentLoginParams.id, kdfAttributes);

    // New KDF salt should be generated.
    newLoginParams.kdfAttributes.setSalt = null;

    var recoveryWallet = await createWallet(
        email,
        password,
        newLoginParams.kdfAttributes,
        (newLoginParams.id),
        newAccounts,
        List.empty());

    recoveryWallet.walletData.addRelation(
        'signer',
        WalletRelation.signer(
            SignerData(recoveryWallet.walletData.attributes.accountId, 0)));

    newLoginParams.kdfAttributes.encodedSalt =
        recoveryWallet.walletData.attributes.salt;

    var newWalletId = recoveryWallet.walletData.id;
    if (newWalletId == null) {
      throw StateError('Missing wallet ID in new wallet data');
    }

    await updateWallet(newWalletId, recoveryWallet.walletData);
    return recoveryWallet;
  }

  //endregion

  //region Static
  static const DEFAULT_SIGNER_ROLE_KEY_VALUE_KEY = 'signer_role:default';
  static const RECOVERY_SIGNER_ROLE_ID = 0;

  static Future<WalletCreateResult> createWallet(
      String email,
      String password,
      KdfAttributes kdfAttributes,
      int kdfVersion,
      List<Account> accounts,
      Iterable<SignerData> signers,
      {String walletType = WalletData.TYPE_DEFAULT,
      String? verificationCode}) async {
    var derivationEmail = email.toLowerCase();

    var kdfSalt = kdfAttributes.salt ?? WalletKeyDerivation.generateKdfSalt();
    var kdfAttributesWithSalt = new KdfAttributes(
        kdfAttributes.algorithm,
        kdfAttributes.bits,
        kdfAttributes.n,
        kdfAttributes.p,
        kdfAttributes.r,
        kdfAttributes.encodedSalt);
    kdfAttributesWithSalt.setSalt = kdfSalt;

    var walletKey = WalletKeyDerivation.deriveWalletEncryptionKey(
        derivationEmail, password, kdfAttributesWithSalt);
    var walletId = WalletKeyDerivation.deriveAndEncodeWalletId(
        derivationEmail, password, kdfAttributesWithSalt);

    var encryptedSeed = WalletEncryption.encryptAccounts(
        derivationEmail, accounts, walletKey, kdfSalt);

    var wallet = WalletData.get(walletType, walletId, encryptedSeed,
        verificationCode: verificationCode);

    wallet.addRelation('kdf', WalletRelation.kdf(kdfVersion));

    var passwordFactorAccount = await Account.random();
    var encryptedPasswordFactor = WalletEncryption.encryptAccount(
        derivationEmail, passwordFactorAccount, walletKey, kdfSalt);

    wallet.addRelation(
        'factor', WalletRelation.password(encryptedPasswordFactor));

    wallet.addArrayRelation(
        'signers', signers.map((signer) => WalletRelation.signer(signer)));

    return WalletCreateResult(
        wallet,
        accounts.first,
        walletId,
        LoginParams('kdf', kdfVersion.toInt(), kdfAttributesWithSalt),
        accounts);
  }

  static Future<int> getDefaultSignerRole(
      KeyValueStorageApiV3 keyValueStorageApiV3) async {
    try {
      var response =
          await keyValueStorageApiV3.getById(DEFAULT_SIGNER_ROLE_KEY_VALUE_KEY);
      return (response['value']['u32']);
    } catch (e) {
      throw StateError("Unable to obtain default role for signer " +
          "by key $DEFAULT_SIGNER_ROLE_KEY_VALUE_KEY");
    }
  }

  /// Creates transaction for password change or recovery
  /// that performs account signers update
  ///
  /// [currentAccount] account of a valid signer to be a tx signer
  /// [signersToRemove] account IDs of signers that will be removed
  static Transaction.Transaction createSignersUpdateTransaction(
      NetworkParams networkParams,
      Account currentAccount,
      String originalAccountId,
      Iterable<SignerData> signersToAdd,
      Iterable<String> signersToRemove) {
    OperationBodyManageSigner? removeCurrentAccountSigner;
    if (signersToRemove.contains(currentAccount.accountId)) {
      removeCurrentAccountSigner = OperationBodyManageSigner(
        ManageSignerOp(
            ManageSignerOpDataRemove(RemoveSignerData(
                currentAccount.xdrPublicKey, EmptyExtEmptyVersion())),
            EmptyExtEmptyVersion()),
      );
    }

    Iterable<OperationBodyManageSigner?> removeSignersButNoCurrent =
        signersToRemove.map((signerToRemove) {
      if (signerToRemove != currentAccount.accountId) {
        return OperationBodyManageSigner(
          ManageSignerOp(
              ManageSignerOpDataRemove(RemoveSignerData(
                  PublicKeyFactory.fromAccountId(signerToRemove),
                  EmptyExtEmptyVersion())),
              EmptyExtEmptyVersion()),
        );
      }
      return null;
    });

    var trBuilder =
        TransactionBuilder.FromPubKey(networkParams, originalAccountId)
            .addSigner(currentAccount)
            .addOperations(
                removeSignersButNoCurrent.where((signer) => signer != null)
                    as List<OperationBodyManageSigner>)
            .addOperations(signersToAdd.map((signerToAdd) {
      return OperationBodyManageSigner(ManageSignerOp(
          ManageSignerOpDataCreate(
            UpdateSignerData(
              PublicKeyFactory.fromAccountId(signerToAdd.id),
              Int64(signerToAdd.roleId),
              signerToAdd.weight,
              signerToAdd.identity,
              signerToAdd.detailsJson ?? '{}',
              EmptyExtEmptyVersion(),
            ),
          ),
          EmptyExtEmptyVersion()));
    }));
    if (removeCurrentAccountSigner != null) {
      trBuilder.addOperation(removeCurrentAccountSigner);
    }

    return trBuilder.build();
  }

//endregion
}
