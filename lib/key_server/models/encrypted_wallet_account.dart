import 'dart:convert';

import 'package:dart_sdk/key_server/models/keychain_data.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dart_sdk/utils/extensions/encoding.dart/';

/// Holds encrypted wallet account data
class EncryptedWalletAccount {
  late final String accountId;
  late final String email;

  /// Base64 encoded KDF salt
  late final String encodedSalt;

  /// Base64 encoded [KeychainData]
  late final String encodedKeychainData;

  EncryptedWalletAccount(
      this.accountId, this.email, this.encodedSalt, this.encodedKeychainData);

  EncryptedWalletAccount.get(String accountId, String email, String encodedSalt,
      KeychainData encodedKeychainData) {
    this.accountId = accountId;
    this.email = email;
    this.encodedSalt = encodedKeychainData.encode();
  }

  EncryptedWalletAccount.fromJson(Map<String, dynamic> json)
      : accountId = json['account_id'],
        email = json['email'],
        encodedSalt = json['encoded_salt'],
        encodedKeychainData = json['keychain_data'];

  Map<String, dynamic> toJson() => {
        'account_id': accountId,
        'email': email,
        'encoded_salt': encodedSalt,
        'keychain_data': encodedKeychainData,
      };

  encode() {
    json.encode(toJson());
  }

  static KeychainData fromRaw(Uint8List iv, Uint8List cipherText) {
    return KeychainData(
        iv.encodeBase64String(), cipherText.encodeBase64String());
  }
}
