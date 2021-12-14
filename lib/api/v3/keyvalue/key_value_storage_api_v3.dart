import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/custom/custom_requests_api.dart';

class KeyValueStorageApiV3 {
  CustomRequestsApi customRequestsApi;

  KeyValueStorageApiV3(this.customRequestsApi);

  /// Return key-value entries list page
  Future<List<dynamic>> get({PagingParamsV2? params}) {
    return customRequestsApi
        .get('v3/key_values', query: params?.map())
        .then((response) {
      return response['data'];
    });
  }

  /// Return key-value entry by it's ID
  Future<Map<String, dynamic>> getById(String id) {
    return customRequestsApi
        .get('v3/key_values/$id')
        .then((json) => json['data']);
  }
}
