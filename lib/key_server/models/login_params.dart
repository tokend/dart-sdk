import 'dart:typed_data';
import 'package:dart_sdk/utils/extensions/encoding.dart';

class LoginParams {
  String type;
  int id;
  KdfAttributes kdfAttributes;

  LoginParams(this.type, this.id, this.kdfAttributes);

  LoginParams.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        id = int.parse(json['id']),
        kdfAttributes = KdfAttributes.fromJson(json['attributes']);
}

class KdfAttributes {
  String algorithm;
  int bits;
  int n;
  int p;
  int r;
  String? encodedSalt;

  KdfAttributes(
      this.algorithm, this.bits, this.n, this.p, this.r, this.encodedSalt);

  KdfAttributes.fromJson(Map<String, dynamic> json)
      : algorithm = json['algorithm'],
        bits = json['bits'],
        n = json['n'],
        p = json['p'],
        r = json['r'],
        encodedSalt = json['salt'];

  Uint8List? get salt => encodedSalt?.decodeBase64();

  set setSalt(Uint8List? value) {
    encodedSalt = value?.encodeBase64String();
  }

  int get bytes => bits ~/ 8;
}
