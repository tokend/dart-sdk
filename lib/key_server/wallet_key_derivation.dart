import 'dart:convert';

import 'package:dart_crypto_kit/crypto_kdf/scrypt_with_master_key_derivation.dart';
import 'package:dart_sdk/key_server/models/login_params.dart';
import 'package:dart_sdk/utils/extensions/converting.dart';
import 'package:dart_sdk/utils/extensions/encoding.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:secure_random/secure_random.dart';

class WalletKeyDerivation {
  static const WALLET_ID_MASTER_KEY = "WALLET_ID";
  static const WALLET_KEY_MASTER_KEY = "WALLET_KEY";
  static const KDF_SALT_LENGTH_BYTES = 16;

  Uint8List deriveWalletEncryptionKey(
      String login, String password, KdfAttributes kdfAttributes) {
    var passwordBytes = utf8.encode(password);

    var result = deriveKey(login.toUInt8List(), password.toUInt8List(),
        WALLET_KEY_MASTER_KEY.toUInt8List(), kdfAttributes);

    passwordBytes.fillRange(0, passwordBytes.length, 0);
    return result;
  }

  Uint8List deriveWalletInfo(
      String login, String password, KdfAttributes kdfAttributes,
      {bool isId = true}) {
    var passwordBytes = utf8.encode(password);

    var masterKey = WALLET_KEY_MASTER_KEY.toUInt8List();
    if (isId) {
      masterKey = WALLET_ID_MASTER_KEY.toUInt8List();
    }
    var result = deriveKey(
        login.toUInt8List(), password.toUInt8List(), masterKey, kdfAttributes);

    passwordBytes.fillRange(0, passwordBytes.length, 0);
    return result;
  }

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

  /// Derives wallet ID for given params and encodes it into HEX
  ///
  /// See [deriveKey]
  String deriveAndEncodeWalletId(
      String login, String password, KdfAttributes kdfAttributes) {
    return deriveWalletInfo(login, password, kdfAttributes).encodeHexString();
  }

  /// Generate salt for system KDF params.
  Uint8List generateKdfSalt({int lengthBytes = KDF_SALT_LENGTH_BYTES}) {
    var sourceRandom = SecureRandom();
    String s = sourceRandom.nextString(length: lengthBytes);
    var source = Uint8List.fromList(s.codeUnits);
    return source;
  }
}
