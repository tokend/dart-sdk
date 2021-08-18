import 'dart:convert';

import 'package:dart_sdk/api/v3/info/model/HorizonStateResource.dart';
import 'package:dio/dio.dart';
import 'package:japx/japx.dart';

class InfoApi {
  final Dio _dio;

  InfoApi(this._dio);

  Future<HorizonStateResource> getSystemInfo() async {
    var response = await _dio.get('v3/info');
    return HorizonStateResource.fromJson(
        Japx.decode(jsonDecode(response.data)));
  }
}
