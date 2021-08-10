import 'dart:typed_data';

import 'package:secure_random/secure_random.dart';

Uint8List getSecureRandomSeed(int length) {
  var sourceRandom = SecureRandom();
  String s = sourceRandom.nextString(length: length);
  return Uint8List.fromList(s.codeUnits);
}