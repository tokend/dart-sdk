import 'package:dart_sdk/api/custom/custom_requests_api.dart';
import 'package:dart_sdk/api/wallets/model/exceptions.dart';
import 'package:dart_sdk/key_server/models/login_params.dart';
import 'package:dart_sdk/key_server/models/wallet_data.dart';
import 'package:dio/dio.dart';

class WalletsApi {
  CustomRequestsApi customRequestsApi;

  WalletsApi(this.customRequestsApi);

  static const String VERIFICATION_META_WALLET_ID = "wallet_id";
  static const String VERIFICATION_META_TOKEN = "token";

  /// Will return specific wallet by given id.
  /// See <a href="https://tokend.gitlab.io/docs/?http#get-wallet">Docs</a>
  Future<WalletData> getById(String walletId,
      {Map<String, dynamic> queryMap = const {}}) {
    try {
      return customRequestsApi
          .get("wallets/$walletId", query: queryMap)
          .then((response) => WalletData.fromJson(response['data']));
    } on DioError catch (e) {
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
  /// See <a href="https://tokend.gitlab.io/docs/?http#get-kdf-params">Docs</a>
  Future<LoginParams> getLoginParams(String? email, bool isRecovery) async {
    try {
      var response = await customRequestsApi.get("wallets/kdf",
          query: {"email": email, "is_recovery": isRecovery});
      return LoginParams.fromJson(response['data']);
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        throw InvalidCredentialsException("Email");
      } else {
        throw e;
      }
    }
  }
}
