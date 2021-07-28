import 'dart:typed_data';

abstract class RequestSigner {
  late String accountId;

  late String originalAccountId;

  Future<String> signToBase64(Uint8List data);
}
