import 'dart:convert';

import 'package:dart_sdk/api/custom/custom_requests_service.dart';
import 'package:dio/dio.dart';
import 'package:japx/japx.dart';

/// Allows to make custom HTTP requests with response body mapping.
///
/// If response class is [String] or [ByteArray] or primitive Java byte array,
/// then no mapping will be performed.
class CustomRequestsApi {
  CustomRequestService customRequestService;
  Dio _dio;

  CustomRequestsApi(this.customRequestService, this._dio);

  //region GET
  Future<Response> _doGet(String url, Map<String, dynamic>? query,
      Map<String, dynamic>? headers) async {
    return customRequestService.get(_dio, url, query ?? {}, headers ?? {});
  }

  Future<Map<String, dynamic>> get(String url, Map<String, dynamic>? query,
      Map<String, dynamic>? headers) async {
    Response response = await _doGet(url, query, headers);
    return Japx.decode(jsonDecode(response.data));
  }

// end region

//region POST
  Future<Response> _doPost(String url, Map<String, dynamic>? query,
      dynamic body, Map<String, dynamic>? headers) {
    return customRequestService.post(
        _dio, url, body, query ?? {}, headers ?? {});
  }

  Future<Map<String, dynamic>> post(String url, Map<String, dynamic>? query,
      dynamic body, Map<String, dynamic>? headers) async {
    Response response = await _doPost(url, body, query, headers);
    return Japx.decode(jsonDecode(response.data));
  }

//end region

//region PUT
  Future<Response> _doPut(String url, Map<String, dynamic>? query, dynamic body,
      Map<String, dynamic>? headers) {
    return customRequestService.put(
        _dio, url, body, query ?? {}, headers ?? {});
  }

  Future<Map<String, dynamic>> put(String url, Map<String, dynamic>? query,
      dynamic body, Map<String, dynamic>? headers) async {
    Response response = await _doPut(url, body, query, headers);
    return Japx.decode(jsonDecode(response.data));
  }

//end region

//region PATCH
  Future<Response> _doPatch(String url, Map<String, dynamic>? query,
      dynamic body, Map<String, dynamic>? headers) {
    return customRequestService.patch(
        _dio, url, body, query ?? {}, headers ?? {});
  }

  Future<Map<String, dynamic>> patch(String url, Map<String, dynamic>? query,
      dynamic body, Map<String, dynamic>? headers) async {
    Response response = await _doPatch(url, body, query, headers);
    return Japx.decode(jsonDecode(response.data));
  }

//end region

//region DELETE
  Future<Response> _doDelete(
      String url, Map<String, dynamic>? query, Map<String, dynamic>? headers) {
    return customRequestService.delete(_dio, url, query ?? {}, headers ?? {});
  }

  Future<Map<String, dynamic>> delete(String url, Map<String, dynamic>? query,
      Map<String, dynamic>? headers) async {
    Response response = await _doDelete(url, query, headers);
    return Japx.decode(jsonDecode(response.data));
  }
//end region

}
