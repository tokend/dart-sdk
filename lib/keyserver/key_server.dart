import 'dart:convert';

import 'package:dart_sdk/api/wallets/wallets_api.dart';
import 'package:dio/dio.dart';
import 'package:japx/japx.dart';

class KeyServer {
  final WalletsApi _walletsApi;

  KeyServer(this._walletsApi);

  void getById(String walletId,
      {Map<String, dynamic> queryMap = const {}}) async {
    Response response = await _walletsApi.getById(walletId, queryMap: queryMap);
    var resultJson = Japx.decode(jsonDecode(response.data));
  }
}
