import 'package:dart_sdk/api/wallets/wallets_api.dart';
import 'package:dart_sdk/key_server/models/login_params.dart';

class KeyServer {
  WalletsApi walletsApi;

  KeyServer(this.walletsApi);

  getWalletInfo(String login, String password,
      {bool isRecovery = false, Map<String, dynamic>? queryMap}) {}

  buildWalletInfo(String login, String password, {bool isRecovery = false, Map<String, dynamic>? queryMap}) async {
    var loginParams = await getLoginParams(login: login, isRecovery: isRecovery);
    var derivationLogin = login.toLowerCase();
  }

  getWalletData(String walletId, {Map<String, dynamic>? queryMap}) {
    walletsApi.getById(walletId, queryMap: queryMap ?? Map());
  }

  /// Loads KDF params.
  /// If no [login] specified will return default [LoginParams] without [KdfAttributes.salt]
  Future<LoginParams> getLoginParams({String? login, bool isRecovery = false}) {
    return walletsApi.getLoginParams(login, isRecovery);
  }
}
