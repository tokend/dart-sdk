import 'package:dart_sdk/api/base/model/forbidden_exception.dart';
import 'package:dart_sdk/api/base/model/server_error.dart';
import 'package:dart_sdk/api/tfa/model/tfa_factor.dart';

class InvalidOtpException implements Exception {
  final String message;

  const InvalidOtpException([this.message = ""]);

  String toString() => "InvalidOtpException: $message";
}

class NeedTfaException extends ForbiddenException {
  final int factorId;
  final TfaFactorType factorType;
  final String token;
  final String keychainData;
  final String salt;
  final String walletId;
  final String messengerBotUrl;

  NeedTfaException(this.factorId, this.factorType, this.token,
      this.keychainData, this.salt, this.walletId, this.messengerBotUrl)
      : super("tfa_required", "Need $factorType TFA");

  static const String TOKEN = "token";
  static const String FACTOR_ID = "factor_id";
  static const String FACTOR_TYPE = "factor_type";
  static const String KEYCHAIN_DATA = "keychain_data";
  static const String SALT = "salt";
  static const String WALLET_ID = "wallet_id";
  static const String MESSENGER_BOT_URL = "bot_url";

  static NeedTfaException? fromError(ServerError error) {
    if (error.detail?.contains("factor") == true) {
      var meta = error.meta;
      return NeedTfaException(
        meta?[FACTOR_ID] ?? 0,
        (meta?[FACTOR_TYPE] ?? null).toString().fromLiteral(),
        (meta?[TOKEN] ?? null).toString(),
        (meta?[KEYCHAIN_DATA] ?? null).toString(),
        (meta?[SALT] ?? null).toString(),
        (meta?[WALLET_ID] ?? null).toString(),
        (meta?[MESSENGER_BOT_URL] ?? null).toString(),
      );
    }
    return null;
  }
}
