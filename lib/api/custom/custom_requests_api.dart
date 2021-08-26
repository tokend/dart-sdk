import 'dart:convert';

import 'package:dart_sdk/api/custom/custom_requests_service.dart';
import 'package:dio/dio.dart';

/// Allows to make custom HTTP requests with response body mapping.
///
/// If response class is [String] or [ByteArray] or primitive Java byte array,
/// then no mapping will be performed.
class CustomRequestsApi {
  CustomRequestService _customRequestService;
  Dio _dio;

  CustomRequestsApi(this._customRequestService, this._dio);

  //region GET
  Future<Response> doGet(String url, Map<String, dynamic>? query,
      Map<String, dynamic>? headers) async {
    return _customRequestService.get(_dio, url, query ?? {}, headers ?? {});
  }

  Future<Map<String, dynamic>> get(String url,
      {Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    Response response = await doGet(url, query, headers);
    if (response.data != null && response.data.toString().length > 0) {
      return jsonDecode(response.data);
    } else {
      return {};
    }
  }

// endregion

  //region POST
  Future<Response> _doPost(String url, Map<String, dynamic>? query,
      dynamic body, Map<String, dynamic>? headers) {
    return _customRequestService.post(
        _dio, url, body, query ?? {}, headers ?? {});
  }

  Future<Map<String, dynamic>> post(String url,
      {Map<String, dynamic>? query,
      dynamic body,
      Map<String, dynamic>? headers}) async {
    Response response = await _doPost(url, query, body, headers);
    if (response.data != null && response.data.toString().length > 0) {
      return json.decode(response.data);
    } else {
      return {};
    }
  }

//endregion

  //region PUT
  Future<Response> _doPut(String url, Map<String, dynamic>? query, dynamic body,
      Map<String, dynamic>? headers) {
    return _customRequestService.put(
        _dio, url, body, query ?? {}, headers ?? {});
  }

  Future<Map<String, dynamic>> put(String url,
      {Map<String, dynamic>? query,
      dynamic body,
      Map<String, dynamic>? headers}) async {
    Response response = await _doPut(url, query, body, headers);
    if (response.data != null && response.data.toString().length > 0)
      return jsonDecode(response.data);
    else
      return {};
  }

//endregion

  //region PATCH
  Future<Response> _doPatch(String url, Map<String, dynamic>? query,
      dynamic body, Map<String, dynamic>? headers) {
    return _customRequestService.patch(
        _dio, url, body, query ?? {}, headers ?? {});
  }

  Future<Map<String, dynamic>> patch(String url,
      {Map<String, dynamic>? query,
      dynamic body,
      Map<String, dynamic>? headers}) async {
    Response response = await _doPatch(url, query, body, headers);
    if (response.data != null && response.data.toString().length > 0) {
      return jsonDecode(response.data);
    } else {
      return {};
    }
  }

//endregion

  //region DELETE
  Future<Response> _doDelete(
      String url, Map<String, dynamic>? query, Map<String, dynamic>? headers) {
    return _customRequestService.delete(_dio, url, query ?? {}, headers ?? {});
  }

  Future<Map<String, dynamic>> delete(String url,
      {Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    Response response = await _doDelete(url, query, headers);
    if (response.data != null && response.data.toString().length > 0) {
      return jsonDecode(response.data);
    } else {
      return {};
    }
  }
//endregion

}
