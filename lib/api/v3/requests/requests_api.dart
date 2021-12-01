import 'package:dart_sdk/api/custom/custom_requests_api.dart';

class RequestsApiV3 {
  CustomRequestsApi customRequestsApi;

  RequestsApiV3(this.customRequestsApi);

  Future<void> getChangeRoleRequests(
      {/*ChangeRoleRequestPageParams?*/ Map<String, dynamic>? params}) {
    //TODO: remove current params type. Only for successful build
    //TODO: Create ChangeRoleRequestPageParams class
    return customRequestsApi.get("v3/change_role_requests",
        query: params /*.toJson()*/);
  }
}
