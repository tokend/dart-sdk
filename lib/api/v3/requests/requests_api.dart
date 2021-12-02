import 'package:dart_sdk/api/custom/custom_requests_api.dart';
import 'package:dart_sdk/api/v3/requests/params/change_role_page_params.dart';
import 'package:dart_sdk/api/v3/requests/params/request_page_params_v3.dart';

class RequestsApiV3 {
  CustomRequestsApi customRequestsApi;

  RequestsApiV3(this.customRequestsApi);

  /// Returns requests list page
  Future<Map<String, dynamic>> get({RequestPageParamsV3? params}) {
    return customRequestsApi.get("v3/requests", query: params?.map());
  }

  /// Returns request by it's ID.
  /// Can only be signed by master
  Future<Map<String, dynamic>> getById(String requestId,
      {RequestPageParamsV3? params}) {
    return customRequestsApi.get("v3/requests/$requestId",
        query: params?.map());
  }

  /// Returns request by it's ID.
  /// This method allows you to sign the request by requestor's signer
  Future<Map<String, dynamic>> requestById(
      String requestorAccount, String requestId,
      {RequestPageParamsV3? params}) {
    return customRequestsApi.get(
        "v3/accounts/$requestorAccount/requests/$requestId",
        query: params?.map());
  }

  /// Will return change role requests list page
  Future<Map<String, dynamic>> getChangeRoleRequests(
      {ChangeRoleRequestPageParams? params}) async {
    return customRequestsApi.get("v3/change_role_requests",
        query: params?.map());
  }

  /// Will return change role requests list page
  Future<Map<String, dynamic>> getAssetCreateRequests(
      {ChangeRoleRequestPageParams? params}) async {
    return customRequestsApi.get("v3/change_role_requests",
        query: params?.map());
  }
}
