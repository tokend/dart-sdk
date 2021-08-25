import 'dart:io';

import 'package:dart_sdk/api/base/model/error_body.dart';
import 'package:dart_sdk/tfa/exceptions.dart';
import 'package:dart_sdk/tfa/tfa_callback.dart';
import 'package:dart_sdk/tfa/tfa_verification_service.dart';
import 'package:dart_sdk/tfa/tfa_verifier.dart';
import 'package:dio/dio.dart';

class TfaInterceptor extends Interceptor {
  TfaVerificationService _verificationService;
  TfaCallback? _tfaCallback;

  TfaInterceptor(this._verificationService, this._tfaCallback);

  @override
  Future<void> onError(DioError error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == HttpStatus.forbidden) {
      var exception = _extractTfaException(error.response!);
      if (exception != null && _tfaCallback != null) {
        var verifier = TfaVerifier(
                TfaVerificationService(_verificationService.dio), exception)
            .onVerified(() async {
          RequestOptions requestOptions = error.requestOptions;
          handler.resolve(await _verificationService.dio.request(
              requestOptions.path,
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
              options: _getOptions(requestOptions)));
        }).onVerificationCancelled(() {
          throw Exception(
              'Request was interrupted due to the cancelled TFA verification');
        });

        _tfaCallback?.onTfaRequired(exception, verifier.verifierInterface);
      }
    }
  }

  Options _getOptions(RequestOptions requestOptions) {
    return Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
  }

  NeedTfaException? _extractTfaException(Response response) {
    var error;
    try {
      var responseString = response.data.toString();
      error = ErrorBody.fromJsonString(responseString).firstOrNull;
    } catch (e) {
      error = null;
    }

    if (error == null) return null;
    var result;
    try {
      result = NeedTfaException.fromError(error);
    } catch (e) {
      result = null;
    }

    return result;
  }
}
