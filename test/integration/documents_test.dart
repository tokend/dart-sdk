import 'dart:convert';

import 'package:dart_sdk/api/custom/custom_requests_service.dart';
import 'package:dart_sdk/api/documents/documents_api.dart';
import 'package:dart_sdk/api/documents/documents_service.dart';
import 'package:dart_sdk/api/documents/model/document_type.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japx/japx.dart';

void main() {
  test('upload document', () async {
    var documentApi =
        DocumentsApi(DocumentsService(), CustomRequestService(), Dio());
    var fileName = "test.txt";
    var document = Uint8List.fromList("Hello World".codeUnits);
    var contentType = "text/plain";

    var uploadPolicy = await documentApi.requestUpload(
        "accountId", DocumentType.GENERAL_PRIVATE, contentType);
    Japx.decode(jsonDecode(uploadPolicy.data));
    print(uploadPolicy);
  });
}
