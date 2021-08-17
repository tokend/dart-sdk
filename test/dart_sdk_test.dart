import 'dart:convert';

import 'package:dart_sdk/api/tfa/model/create_tfa_request_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:japx/japx.dart';

class Tmp {
  String field1;
  String field2;

  Tmp(this.field1, this.field2);

  Map<String, dynamic> toJson() => {
        'field1': field1,
        'field2': field2,
      };
}

void main() {
  test('adds one to input values', () async {
    var tmp = CreateTfaRequestBody("test");
    print(Japx.encode(jsonEncode({"priority": "TEST"})));

    /*CustomRequestsApi customRequestsApi = CustomRequestsApi(
        CustomRequestService(),
        Dio()..interceptors.add(LogInterceptor(requestBody: true)));
    var response = await customRequestsApi.patch(
        "http://api.rdemo.tokend.io/integrations/history",
        query: null,
        body: tmp.toJson());
    print(response["data"]);*/
  });
}
