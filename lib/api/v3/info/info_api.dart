
import 'package:dart_sdk/api/custom/custom_requests_api.dart';
import 'package:dart_sdk/api/v3/info/model/HorizonStateResource.dart';
import 'package:japx/japx.dart';

class InfoApi {
  final CustomRequestsApi _service;

  InfoApi(this._service);

  Future<HorizonStateResource> getSystemInfo() async {
    var response = await _service.get('v3/info');
    return HorizonStateResource.fromJson(Japx.decode(response));
  }
}
