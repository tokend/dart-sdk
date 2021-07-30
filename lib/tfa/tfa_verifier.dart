import 'package:dart_sdk/api/tfa/model/verify_tfa_request_body.dart';
import 'package:dart_sdk/tfa/callbacks.dart';
import 'package:dart_sdk/tfa/tfa_verification_service.dart';
import 'package:japx/japx.dart';

/// Performs OTP verification.
class TfaVerifier {
  final TfaVerificationService service;
  final String _walletId;
  final int _factorId;
  final String _token;

  late InterfaceImpl verifierInterface;

  TfaVerifier(this.service, this._walletId, this._factorId, this._token) {
    this.verifierInterface = InterfaceImpl(this);
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

  void verify(String otp,
      {EmptyCallback? onSuccess, OptionalThrowableCallback? onError}) {
    final data = Japx.encode(VerifyTfaRequestBody(_token, otp)..toJson());
    service
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
  void verify(String otp,
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
  void verify(String otp,
      {EmptyCallback? onSuccess, OptionalThrowableCallback? onError}) {
    _tfaVerifier.verify(otp,
        onSuccess: () =>
            {_tfaVerifier.onVerifiedCallback?.call(), onSuccess?.call()},
        onError: onError);
  }

  /// Informs verifier that verification will not be performed.
  /// Original request will be then failed with the Exception
  @override
  void cancelVerification() {
    _tfaVerifier.onVerificationCancelledCallback?.call();
  }
}
