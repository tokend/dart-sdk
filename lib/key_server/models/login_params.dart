import 'dart:ffi';
import 'dart:typed_data';
import 'package:dart_sdk/utils/extensions/encoding.dart/';

class LoginParams {
  String type;
  Int64 id;
  KdfAttributes kdfAttributes;

  LoginParams(this.type, this.id, this.kdfAttributes);

  LoginParams.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        id = json['id'],
        kdfAttributes = json['attributes'];
}

class KdfAttributes {
  late String algorithm;
  late int bits;
  late int n;
  late int p;
  late int r;
  late String? encodedSalt;

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

  set setSalt(Uint8List value) {
    encodedSalt = value.encodeBase64String();
  }

  int get bytes => bits ~/ 8;
}
