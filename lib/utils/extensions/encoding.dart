import 'dart:convert';
import 'dart:typed_data';

extension EncodingString on String {
  Uint8List decodeBase64() {
    return base64Decode(this);
  }
}

extension EncodingUint8List on Uint8List {}
