import 'package:dart_sdk/key_server/models/keychain_data.dart';
import 'package:dart_sdk/key_server/models/login_params.dart';
import 'package:dart_sdk/key_server/wallet_encryption.dart';
import 'package:dart_sdk/key_server/wallet_key_derivation.dart';
import 'package:dart_sdk/tfa/exceptions.dart';
import 'package:dart_wallet/account.dart';
import 'package:dart_sdk/utils/extensions/converting.dart';
import 'package:dart_sdk/utils/extensions/encoding.dart';

class PasswordTfaOtpGenerator {
  Future<String> generate(NeedTfaException tfaException, String email,
      String password) async {
    var kdfAttributes =
    KdfAttributes('scrypt', 256, 4096, 1, 8, tfaException.salt);

    var key = WalletKeyDerivation.deriveWalletEncryptionKey(
        email, password, kdfAttributes);
    var keychainData = KeychainData.fromEncoded(tfaException.keychainData);
    var seed = '';
    try {
      WalletEncryption.decryptSecretSeed(keychainData, key);
    } catch (e) {} finally {
      key.fillRange(0, key.length, 0);
    }

    var account = await Account.fromSecretSeed(seed);
    var signature = await account.sign(tfaException.token.toUInt8List());

    return signature.encodeBase64String();
  }
}
