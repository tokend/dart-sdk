import 'package:dart_wallet/xdr/utils/dependencies.dart';

extension Convert on String {
  Uint8List toUInt8List() {
    return Uint8List.fromList(this.codeUnits);
  }
}
