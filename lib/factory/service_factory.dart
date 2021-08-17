import 'package:dart_sdk/api/custom/custom_requests_api.dart';
import 'package:dart_sdk/api/custom/custom_requests_service.dart';
import 'package:dart_sdk/signing/request_signer.dart';
import 'package:dart_sdk/signing/sign_interceptor.dart';
import 'package:dart_sdk/tfa/tfa_callback.dart';
import 'package:dart_sdk/tfa/tfa_interceptor.dart';
import 'package:dart_sdk/tfa/tfa_verification_service.dart';
import 'package:dio/dio.dart';

class ServiceFactory {
  String _url;
  bool _withLogs;
  Map<String, String?>? _extraHeaders;

  ServiceFactory(this._url, this._withLogs, this._extraHeaders);

  static const _HEADER_ACCEPT_NAME = "Accept";
  static const _HEADER_CONTENT_TYPE_NAME = "Content-Type";
  static const _CONTENT_TYPE = "application/vnd.api+json";

  TfaVerificationService getTfaVerificationService() {
    var options =
        BaseOptions(baseUrl: _url, headers: _getDefaultHeaders(_extraHeaders));
    Dio _dio = Dio(options);
    return TfaVerificationService(_dio);
  }

  CustomRequestsApi getService(
      {RequestSigner? requestSigner, TfaCallback? tfaCallback}) {
    var options =
        BaseOptions(baseUrl: _url, headers: _getDefaultHeaders(_extraHeaders));
    Dio _dio = Dio(options);

    if (_withLogs) {
      _dio.interceptors.add(LogInterceptor(responseBody: true));
    }
    if (requestSigner != null) {
      _dio.interceptors.add(SignInterceptor(_url, requestSigner));
    }
    if (tfaCallback != null) {
      _dio.interceptors
          .add(TfaInterceptor(getTfaVerificationService(), tfaCallback));
    }
    return new CustomRequestsApi(CustomRequestService(), _dio);
  }

  Map<String, String?> _getDefaultHeaders(Map<String, String?>? extraHeaders) {
    var defaultMap = {
      _HEADER_CONTENT_TYPE_NAME: _CONTENT_TYPE,
      _HEADER_ACCEPT_NAME: _CONTENT_TYPE
    };
    if (extraHeaders != null) {
      defaultMap.addAll(filterNotNullValues(extraHeaders));
    }
    return defaultMap;
  }

  Map<String, String> filterNotNullValues(Map<String, String?> map) {
    Map<String, String?> tmp = map..removeWhere((key, value) => value != null);
    return tmp.map((key, value) => MapEntry(key, value as String));
  }
}
