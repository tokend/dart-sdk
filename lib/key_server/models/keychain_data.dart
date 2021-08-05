import 'dart:convert';

import 'package:dart_sdk/utils/extensions/encoding.dart/';
import 'package:dart_wallet/xdr/utils/dependencies.dart';

class KeychainData {
  final String encodedIv;
  final String encodedCipherText;
  final String cipherName;
  final String cipherMode;

  /// Raw bytes of the init vector.
  Uint8List get iv => encodedIv.decodeBase64();

  /// Raw bytes of the encrypted data
  Uint8List get cipherText => encodedCipherText.decodeBase64();

  KeychainData(this.encodedIv, this.encodedCipherText,
      {this.cipherName = "aes", this.cipherMode = "gcm"});

  KeychainData.getFromJson(Map<String, dynamic> json)
      : encodedIv = json['IV'],
        encodedCipherText = json['cipherText'],
        cipherName = json['cipherName'],
        cipherMode = json['modeName'];

  Map<String, dynamic> toJson() => {
        'IV': encodedIv,
        'cipherText': encodedCipherText,
        'cipherName': cipherName,
        'modeName': cipherMode,
      };

  String encode() {
    return Uint8List.fromList(json.encode(toJson()).codeUnits)
        .encodeBase64String();
  }

  static KeychainData fromJson(String rawJson) {
    return KeychainData.getFromJson(
        json.decode(rawJson) as Map<String, dynamic>);
  }

  static KeychainData fromRaw(Uint8List iv, Uint8List cipherText) {
    return KeychainData(
        iv.encodeBase64String(), cipherText.encodeBase64String());
  }
}
