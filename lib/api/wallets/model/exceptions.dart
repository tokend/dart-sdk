import 'package:dart_sdk/api/base/model/forbidden_exception.dart';

class InvalidCredentialsException implements Exception {
  final String message;

  const InvalidCredentialsException([this.message = ""]);

  String toString() => "InvalidCredentialsException: $message";
}

class EmailNotVerifiedException extends ForbiddenException {
  final String walletId;

  EmailNotVerifiedException(this.walletId)
      : super("email_not_verified", "Email is not verified");
}

class EmailAlreadyTakenException implements Exception {
  final String message;

  const EmailAlreadyTakenException([this.message = ""]);

  String toString() => "EmailAlreadyTakenException: $message";
}
