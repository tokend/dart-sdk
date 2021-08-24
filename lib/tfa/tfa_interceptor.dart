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
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    // TODO: implement onError
    if (err.response != null &&
        err.response?.statusCode == HttpStatus.forbidden) {
      var exception = extractTfaException(err.response!);
      if (exception != null && _tfaCallback != null) {
        var verifier = TfaVerifier.get(_verificationService, exception.walletId,
            exception.factorId, exception.token);

        _tfaCallback?.onTfaRequired(
            exception, verifier.verifierInterface); //TODO

        //TODO
      } else if (exception != null) {
        throw exception;
      } else {
        handler.next(err);
      }
    } else {
      super.onError(err, handler);
    }
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
