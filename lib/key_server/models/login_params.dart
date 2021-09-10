import 'dart:typed_data';

import 'package:dart_sdk/utils/extensions/encoding.dart';

class LoginParams {
  String type;
  int id;
  KdfAttributes kdfAttributes;

  LoginParams(this.type, this.id, this.kdfAttributes);

  LoginParams.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        id = int.parse(json['id'].toString()),
        kdfAttributes = KdfAttributes.fromJson(json['attributes']);

  Map<String, dynamic> toJson() =>
      {'type': type, 'id': id, 'attributes': kdfAttributes.toJson()};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginParams &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          id == other.id &&
          kdfAttributes == other.kdfAttributes;

  @override
  int get hashCode => type.hashCode ^ id.hashCode ^ kdfAttributes.hashCode;
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

  Map<String, dynamic> toJson() => {
        'algorithm': algorithm,
        'bits': bits,
        'n': n,
        'p': p,
        'r': r,
        'salt': encodedSalt
      };

  KdfAttributes.fromJson(Map<String, dynamic> json)
      : algorithm = json['algorithm'],
        bits = json['bits'],
        n = json['n'],
        p = json['p'],
        r = json['r'] {
    encodedSalt = getSalt(json['salt']);
  }

  String getSalt(dynamic json) {
    if (json is String) {
      return json;
    } else {
      return String.fromCharCodes(json.cast<int>());
    }
  }

  Uint8List? get salt => encodedSalt?.decodeBase64();

  set setSalt(Uint8List? value) {
    encodedSalt = value?.encodeBase64String();
  }

  int get bytes => bits ~/ 8;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KdfAttributes &&
          runtimeType == other.runtimeType &&
          algorithm == other.algorithm &&
          bits == other.bits &&
          n == other.n &&
          p == other.p &&
          r == other.r &&
          encodedSalt == other.encodedSalt;

  @override
  int get hashCode =>
      algorithm.hashCode ^
      bits.hashCode ^
      n.hashCode ^
      p.hashCode ^
      r.hashCode ^
      encodedSalt.hashCode;
}
