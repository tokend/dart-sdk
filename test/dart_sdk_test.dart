import 'package:dart_sdk/api/custom/custom_requests_api.dart';
import 'package:dart_sdk/api/custom/custom_requests_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class Tmp {
  String field1;
  int? field2;

  Tmp(this.field1, this.field2);

  Map<String, dynamic> toJson() => {
        'field1': field1,
        'field2': field2,
      };
}

void main() {
  test('adds one to input values', () async {
    var tmp = Tmp("test", 1);
    CustomRequestsApi customRequestsApi = CustomRequestsApi(
        CustomRequestService(),
        Dio()..interceptors.add(LogInterceptor(requestBody: true)));
    var response = await customRequestsApi.patch(
        "http://api.rdemo.tokend.io/integrations/history",
        query: null,
        body: tmp.toJson());
    print(response["data"]);
  });
}
