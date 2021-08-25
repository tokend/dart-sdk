import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:dart_sdk/api/custom/custom_requests_api.dart';

class SignersApiV3 {
  CustomRequestsApi customRequestsApi;

  SignersApiV3(this.customRequestsApi);

  //region Endpoints

  /// Return signers list of provided account id.
  Future<Map<String, dynamic>> get(String accountId) async {
    return customRequestsApi.get('v3/accounts/$accountId/signers');
  }

  /// Return signers roles page.
  Future<DataPage> getRoles() {
    return customRequestsApi
        .get('v3/signer_roles')
        .then((roles) => DataPage.fromPageDocument(roles));
  }

  /// Return role by it's id.
  Future<Map<String, dynamic>> getRoleById(String id) {
    return customRequestsApi.get('v3/signer_roles/$id');
  }

  /// Return signers rules page.
  Future<DataPage> getRules() {
    return customRequestsApi
        .get('v3/signer_rules')
        .then((rules) => DataPage.fromPageDocument(rules));
  }

  /// Return rule by it's id.
  Future<DataPage> getRuleById(String id) {
    return customRequestsApi
        .get('v3/signer_rules/$id')
        .then((rules) => DataPage.fromPageDocument(rules));
  }

  //endregion
}
