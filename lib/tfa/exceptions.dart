/*
import 'package:dart_sdk/api/base/model/forbidden_exception.dart';
import 'package:dart_sdk/api/base/model/server_error.dart';

class InvalidOpException implements Exception {
  final String message;

  const InvalidOpException([this.message = ""]);

  String toString() => "InvalidOpException: $message";
}

class NeedTfaException extends ForbiddenException {
  final int factorId;
  final TfaFactor.Type factorType;
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

  static NeedTfaException fromError(ServerError error){
    if(error.detail.contains("factor") == true){
      var meta = error.meta;
      return NeedTfaException(
          meta?[FACTOR_ID] ?? 0,
          meta?[FACTOR_TYPE].toString(),
          meta?[TOKEN].toString(),
          meta?[KEYCHAIN_DATA].toString(),
          meta?[SALT].toString(),
          meta?[WALLET_ID].toString(),
          meta?[MESSENGER_BOT_URL].toString());
    }
  }
}
*/
