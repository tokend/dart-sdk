import 'package:dart_sdk/api/tfa/model/verify_tfa_request_body.dart';
import 'package:dart_sdk/tfa/callbacks.dart';
import 'package:dart_sdk/tfa/exceptions.dart';
import 'package:dart_sdk/tfa/tfa_verification_service.dart';
import 'package:japx/japx.dart';

/// Performs OTP verification.
class TfaVerifier {
  late final TfaVerificationService service;
  late final String _walletId;
  late final int _factorId;
  late final String _token;

  InterfaceImpl get verifierInterface => InterfaceImpl(this);

  TfaVerifier.get(this.service, this._walletId, this._factorId, this._token);

  TfaVerifier(TfaVerificationService service, NeedTfaException tfaException) {
    TfaVerifier.get(service, tfaException.walletId, tfaException.factorId,
        tfaException.token);
  }

  EmptyCallback? onVerifiedCallback;
  EmptyCallback? onVerificationCancelledCallback;

  TfaVerifier onVerified(EmptyCallback callback) {
    onVerifiedCallback = callback;
    return this;
  }

  TfaVerifier onVerificationCancelled(EmptyCallback callback) {
    onVerificationCancelledCallback = callback;
    return this;
  }

  Future<void> verify(String otp,
      {EmptyCallback? onSuccess, OptionalThrowableCallback? onError}) async {
    final data = Japx.encode(VerifyTfaRequestBody(_token, otp).toJson());
    await service
        .verifyTfaFactor(data, _walletId, _factorId)
        .then((value) => value.statusCode)
        .catchError((error, stacktrace) {
      onError?.call(error);
      print(stacktrace);
    }).whenComplete(() => onSuccess?.call());
  }
}

abstract class Interface {
  /// Performs OTP verification.
  /// If OTP was verified successfully original request will be completed.
  verify(String otp,
      {EmptyCallback? onSuccess, OptionalThrowableCallback? onError});

  /// Informs verifier that verification will not be performed.
  /// Original request will be then failed with the Exception
  void cancelVerification();
}

class InterfaceImpl implements Interface {
  final TfaVerifier _tfaVerifier;

  InterfaceImpl(this._tfaVerifier);

  /// Performs OTP verification.
  /// If OTP was verified successfully original request will be completed.
  @override
  Future<void> verify(String otp,
      {EmptyCallback? onSuccess, OptionalThrowableCallback? onError}) async {
    await _tfaVerifier.verify(otp, onSuccess: () {
      _tfaVerifier.onVerifiedCallback?.call();
      onSuccess?.call();
    }, onError: onError);
  }

  /// Informs verifier that verification will not be performed.
  /// Original request will be then failed with the Exception
  @override
  void cancelVerification() {
    _tfaVerifier.onVerificationCancelledCallback?.call();
  }
}
