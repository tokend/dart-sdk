import 'package:dart_sdk/api/custom/custom_requests_api.dart';
import 'package:dart_sdk/api/custom/custom_requests_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () async {
    CustomRequestsApi customRequestsApi =
        CustomRequestsApi(CustomRequestService(), Dio());
    var response = await customRequestsApi.get(
        "http://api.rdemo.tokend.io/integrations/history", {}, null);
    print(response["data"]);
  });
}
