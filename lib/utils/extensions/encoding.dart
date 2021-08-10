import 'dart:convert';
import 'dart:typed_data';

import 'package:hex/hex.dart';

extension EncodingString on String {
  Uint8List decodeBase64() {
    return base64Decode(this);
  }
}

extension EncodingUint8List on Uint8List {
  String encodeBase64String() {
    return base64Encode(this);
  }

  String encodeHexString() {
    return HEX.encode(this);
  }
}
