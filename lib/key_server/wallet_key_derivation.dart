import 'package:dart_sdk/key_server/models/login_params.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dart_crypto_kit/crypto_kdf/scrypt_with_master_key_derivation.dart';
import 'package:secure_random/secure_random.dart';

class WalletKeyDerivation {
  static const WALLET_ID_MASTER_KEY = "WALLET_ID";
  static const WALLET_KEY_MASTER_KEY = "WALLET_KEY";
  static const KDF_SALT_LENGTH_BYTES = 16;

 /* Uint8List deriveWalletEncryptionKey(
      String login, String password, KdfAttributes kdfAttributes) {
    var passwordBuffer = StringBuffer(password);
  }*/

  /// Derives wallet key for given params
  /// See [ScryptWithMasterKeyDerivation]
  /// See <a href="https://tokend.gitlab.io/docs/#wallet-id-derivation">Wallet key derivation docs</a>
  Uint8List deriveKey(Uint8List login, Uint8List password, Uint8List masterKey,
      KdfAttributes kdfAttributes) {
    var derivation = ScryptWithMasterKeyDerivation(
        kdfAttributes.n, kdfAttributes.r, kdfAttributes.p, login, masterKey);
    var salt = kdfAttributes.salt;
    if (salt == null) {
      throw ArgumentError("KDF salt is required for derivation");
    }
    return derivation.derive(password, salt, kdfAttributes.bytes);
  }

  /*Uint8List deriveWalletId(
      String login, String password, KdfAttributes kdfAttributes) {

  }*/

/* Uint8List generateKdfSalt({int lengthBytes = KDF_SALT_LENGTH_BYTES}) {
    return SecureRandom()//TODO ask Oleg Nachalnik
  }*/
}
