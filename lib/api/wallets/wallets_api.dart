import 'dart:convert';

import 'package:dart_sdk/api/base/model/attributes_entity.dart';
import 'package:dart_sdk/api/base/model/data_entity.dart';
import 'package:dart_sdk/api/custom/custom_requests_api.dart';
import 'package:dart_sdk/api/wallets/model/exceptions.dart';
import 'package:dart_sdk/api/wallets/model/verify_wallet_resource_body.dart';
import 'package:dart_sdk/api/wallets/model/wallet_resource_body.dart';
import 'package:dart_sdk/key_server/models/login_params.dart';
import 'package:dart_sdk/key_server/models/wallet_data.dart';
import 'package:dart_sdk/redirects/client_redirect_payload.dart';
import 'package:dart_sdk/redirects/client_redirect_type.dart';
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
    return customRequestsApi
        .get("wallets/$walletId", query: queryMap)
        .then((response) => WalletData.fromJson(response['data']))
        .onError((error, stackTrace) {
      switch ((error as DioError).response?.statusCode) {
        case 403:
          throw EmailNotVerifiedException(walletId);
        case 404:
          throw InvalidCredentialsException("Password");
        case 410:
          throw InvalidCredentialsException("Password");
        default:
          throw error;
      }
    });
  }

  /// Will create new wallet.
  /// See <a href="https://tokend.gitlab.io/docs/?http#create-wallet">Docs</a>
  Future<WalletData> create(WalletData data) async {
    return customRequestsApi
        .post('wallets', body: json.encode(WalletResourceBody(data).toJson()))
        .then((response) => WalletData.fromJson(response['data']))
        .onError((error, stackTrace) {
      switch ((error as DioError).response?.statusCode) {
        case 409:
          throw EmailAlreadyTakenException();
        default:
          throw error;
      }
    });
  }

  /// Request is similar to wallet [create] but also contains additional transaction resource
  /// used to update account signers.
  /// See <a href="https://tokend.gitlab.io/docs/?http#update-wallet">Docs</a>
  Future<void> update(String walletId, WalletData data) {
    return customRequestsApi.put('wallets/$walletId',
        body: json.encode(WalletResourceBody(data).toJson()));
  }

  /// Verifies wallet with given ID.
  /// See <a href="https://tokend.gitlab.io/docs/?http#wallet-verification">Docs</a>
  Future<void> verify(String walletId, String token) {
    return customRequestsApi.put('wallets/$walletId/verification',
        body: DataEntity(AttributesEntity(VerifyWalletRequestBody(token))));
  }

  /// Verifies wallet by given redirect payload.
  /// See [verify(walletId, token)]
  Future<void> verifyByPayload(ClientRedirectPayload redirectPayload) {
    if (redirectPayload.type != ClientRedirectType.EMAIL_VERIFICATION) {
      throw ArgumentError('Invalid redirect payload');
    }

    var walletId = (json.decode(redirectPayload.meta)
        as Map<String, dynamic>)[VERIFICATION_META_WALLET_ID];

    if (walletId == null) {
      throw ArgumentError('Missing $VERIFICATION_META_WALLET_ID in meta data');
    }

    var token = (json.decode(redirectPayload.meta)
        as Map<String, dynamic>)[VERIFICATION_META_TOKEN];

    if (token == null) {
      throw ArgumentError('Missing $VERIFICATION_META_TOKEN in meta data');
    }

    return verify(walletId, token);
  }

  /// Will requesting verification resend.
  /// See <a href="https://tokend.gitlab.io/docs/?http#requesting-verification-resend">Docs</a>
  Future<void> requestVerification(String walletId) {
    return customRequestsApi.post('wallets/$walletId/verification');
  }

  /// Will return current default derivation parameters or parameters used to derive specific wallet.
  /// See <a href="https://tokend.gitlab.io/docs/?http#get-kdf-params">Docs</a>
  Future<LoginParams> getLoginParams(String? email, bool isRecovery) async {
    var response = await customRequestsApi.get("wallets/kdf", query: {
      "email": email,
      "is_recovery": isRecovery
    }).onError((error, stackTrace) {
      if ((error as DioError).response?.statusCode == 404) {
        throw InvalidCredentialsException("Email");
      } else {
        throw error;
      }
    });
    return LoginParams.fromJson(response['data']);
  }
}
