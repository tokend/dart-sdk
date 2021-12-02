import 'package:dart_sdk/api/v3/base/json_api_query_params.dart';

class RequestParamsV3 extends JsonApiQueryParams {
  RequestParamsV3(List<String>? include) : super(include);
}

class RequestParamsV3Includes {
  static const REQUEST_DETAILS = "request_details";
  static const REQUESTOR = "requestor";
  static const REVIEWER = "reviewer";
}
