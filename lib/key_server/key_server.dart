import 'package:dart_sdk/api/wallets/wallets_api.dart';
import 'package:dart_sdk/key_server/models/login_params.dart';
import 'package:dart_sdk/key_server/models/wallet_data.dart';
import 'package:dart_sdk/key_server/models/wallet_info.dart';
import 'package:dart_sdk/key_server/wallet_encryption.dart';
import 'package:dart_sdk/key_server/wallet_key_derivation.dart';

class KeyServer {
  WalletsApi walletsApi;

  KeyServer(this.walletsApi);

  // region Obtain
  /// Loads user's wallet and decrypts secret seed.
  /// See buildWalletInfo
  Future<WalletInfo> getWalletInfo(String login, String password,
      {bool isRecovery = false, Map<String, dynamic>? queryMap}) {
    return buildWalletInfo(login, password);
  }

  /// See getLoginParams
  /// See getWalletData
  Future<WalletInfo> buildWalletInfo(String login, String password,
      {bool isRecovery = false, Map<String, dynamic>? queryMap}) async {
    var loginParams =
        await getLoginParams(login: login, isRecovery: isRecovery);
    var derivationLogin = login.toLowerCase();

    var hexWalletId = WalletKeyDerivation.deriveAndEncodeWalletId(
        derivationLogin, password, loginParams.kdfAttributes);
    var walletKey = WalletKeyDerivation.deriveWalletEncryptionKey(
        derivationLogin, password, loginParams.kdfAttributes);

    var walletData = await getWalletData(hexWalletId, queryMap: queryMap);

    var keychainData = walletData.attributes.keychainData;
    var accountId = walletData.attributes.accountId;
    var email = walletData.attributes.email;

    if (isRecovery) {
      return WalletInfo(
        accountId,
        email,
        hexWalletId,
        loginParams,
        List.of([password]),
      );
    } else {
      return WalletInfo(
        accountId,
        email,
        hexWalletId,
        loginParams,
        WalletEncryption.decryptSecretSeeds(keychainData, walletKey),
      );
    }
  }

  /// Loads wallet by wallet ID.
  Future<WalletData> getWalletData(String walletId,
      {Map<String, dynamic>? queryMap}) {
    return walletsApi.getById(walletId, queryMap: queryMap ?? Map());
  }

  /// Loads KDF params.
  /// If no [login] specified will return default [LoginParams] without [KdfAttributes.salt]
  Future<LoginParams> getLoginParams({String? login, bool isRecovery = false}) {
    return walletsApi.getLoginParams(login, isRecovery);
  }
// endregion
}
