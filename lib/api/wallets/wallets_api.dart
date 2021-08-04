import 'dart:convert';

import 'package:dart_sdk/api/wallets/model/exceptions.dart';
import 'package:dart_sdk/key_server/models/login_params.dart';
import 'package:dart_sdk/key_server/models/wallet_data.dart';
import 'package:dio/dio.dart';
import 'package:japx/japx.dart';

class WalletsApi {
  final Dio _dio;

  WalletsApi(this._dio);

  static const String VERIFICATION_META_WALLET_ID = "wallet_id";
  static const String VERIFICATION_META_TOKEN = "token";

  /// Will return specific wallet by given id.
  /// @see <a href="https://tokend.gitlab.io/docs/?http#get-wallet">Docs</a>
  Future<WalletData> getById(String walletId,
      {Map<String, dynamic> queryMap = const {}}) {
    try {
      return _dio
          .get("wallets/$walletId", queryParameters: queryMap)
          .then((response) =>
          WalletData.fromJson(Japx.decode(jsonDecode(response.data))));
      } on DioError catch (e)
      {
        switch (e.response?.statusCode) {
          case 403:
            throw EmailNotVerifiedException(walletId);
          case 404:
          case 410:
            throw InvalidCredentialsException("Password");
          default:
            throw e;
        }
      }
    }

  /// Will return current default derivation parameters or parameters used to derive specific wallet.
  /// @see <a href="https://tokend.gitlab.io/docs/?http#get-kdf-params">Docs</a>
  Future<LoginParams> getLoginParams(String? email, bool isRecovery) async {
    try {
      var response = await _dio.get("wallets/kdf",
          queryParameters: {"email": email, "is_recovery": isRecovery});
      return LoginParams.fromJson(Japx.decode(jsonDecode(response.data)));
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        throw InvalidCredentialsException("Email");
      } else {
        throw e;
      }
    }
  }
}
