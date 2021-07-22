import 'dart:convert';

import 'package:dio/dio.dart';

class CustomRequestService {
  Future<Response> get(Dio dio, String url, Map<String, dynamic> query,
      Map<String, dynamic> headers) {
    return dio.get(url,
        queryParameters: query, options: Options(headers: headers));
  }

  Future<Response> post(Dio dio, String url, dynamic body,
      Map<String, dynamic> query, Map<String, dynamic> headers) {
    return dio.post(url,
        queryParameters: query,
        data: jsonEncode(body),
        options: Options(headers: headers));
  }

  Future<Response> put(Dio dio, String url, dynamic body,
      Map<String, dynamic> query, Map<String, dynamic> headers) {
    return dio.put(url,
        queryParameters: query,
        data: jsonEncode(body),
        options: Options(headers: headers));
  }

  Future<Response> patch(Dio dio, String url, dynamic body,
      Map<String, dynamic> query, Map<String, dynamic> headers) {
    return dio.patch(url,
        queryParameters: query,
        data: jsonEncode(body),
        options: Options(headers: headers));
  }

  Future<Response> delete(Dio dio, String url, Map<String, dynamic> query,
      Map<String, dynamic> headers) {
    return dio.delete(url,
        queryParameters: query, options: Options(headers: headers));
  }
}
