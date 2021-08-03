import 'package:dart_sdk/utils/extensions/encoding.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';

class LoginParams {
  final String type;
  final int id;
  final String algorithm;
  final int bits;
  final int n;
  final int p;
  final int r;
  String? encodedSalt;

  LoginParams(this.type, this.id, this.algorithm, this.bits, this.n, this.p,
      this.r, this.encodedSalt);

  LoginParams.fromJson(Map<String, dynamic> json)
      : type = json["type"],
        id = json["id"],
        algorithm = json["algorithm"],
        bits = json["bits"],
        n = json["n"],
        p = json["p"],
        r = json["r"],
        encodedSalt = json["salt"];

  Uint8List? get salt {
    return encodedSalt?.decodeBase64();
  }

  set salt(Uint8List? value) => encodedSalt = value?.encodeBase64String();

  int get bytes {
    return bits ~/ 8;
  }
}
