import 'package:dio/dio.dart';

class InfoApi {
  final Dio _dio;

  InfoApi(this._dio);

  void getSystemInfo() async {
    var response = await _dio.get('v3/info');
  }
}
