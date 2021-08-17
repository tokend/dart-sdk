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
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    response.data.toString();
    if (response.statusCode == HttpStatus.forbidden) {
      var exception = extractTfaException(response);
      if (exception != null && _tfaCallback != null) {
        var verifier = TfaVerifier(_verificationService, exception)
            .onVerified(() {})
            .onVerificationCancelled(() {
          throw Exception(
              'Request was interrupted due to the cancelled TFA verification');
        });

        _tfaCallback?.onTfaRequired(
            exception, verifier.verifierInterface); //TODO

      }
    }
    super.onResponse(response, handler);
  }

  NeedTfaException? extractTfaException(Response response) {
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
