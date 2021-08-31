import 'dart:typed_data';

import 'package:dart_wallet/utils/random.dart';

Uint8List getSecureRandomSeed(int length) {
  String s =  Randomizer.getRandomString(length);
  return Uint8List.fromList(s.codeUnits);
}