import 'package:dio/dio.dart';

class WalletsApi {
  final Dio _dio;

  WalletsApi(this._dio);

  static const String VERIFICATION_META_WALLET_ID = "wallet_id";
  static const String VERIFICATION_META_TOKEN = "token";

  /// Will return specific wallet by given id.
  /// @see <a href="https://tokend.gitlab.io/docs/?http#get-wallet">Docs</a>
  void getById(String walletId, {Map<String, dynamic> queryMap = const {}}) {
    _dio.get("wallets/$walletId",
        queryParameters: queryMap);
  }

  /// Will return current default derivation parameters or parameters used to derive specific wallet.
  /// @see <a href="https://tokend.gitlab.io/docs/?http#get-kdf-params">Docs</a>
  void getLoginParams(String? email, bool isRecovery)
}