import 'dart:convert';

import 'package:dart_sdk/api/tfa/model/create_tfa_request_body.dart';
import 'package:dart_sdk/api/tfa/model/tfa_factor.dart';
import 'package:dart_sdk/api/tfa/model/tfa_factor_attributes.dart';
import 'package:dio/dio.dart';
import 'package:japx/japx.dart';

class TfaApi {
  final Dio _dio;

  TfaApi(this._dio);

  Future<List<TfaFactor>> getFactors(String walletId) {
    var response = _dio.get("wallets/$walletId/factors");
    var tmp = response.then((value) =>
        (Japx.decode(jsonDecode(value.data)) as List)
            .map((e) => TfaFactor.fromJson(e)) as List<TfaFactor>);
    return tmp;
  }

  Future<Map<String, dynamic>> createFactor(
      String walletId, CreateTfaRequestBody createTfaRequestBody) {
    return _dio
        .post("wallets/{walletId}/factors",
            data: Japx.decode(createTfaRequestBody.toJson()))
        .then((value) => jsonDecode(value.data));
  }

  void deleteFactor(String walletId, int factorId) {
    _dio.delete("wallets/$walletId/factors/$factorId");
  }

  void updateFactor(String walletId, int factorId, String priority) {
    var tfaAttributes = TfaFactorAttributes(priority);
    _dio.patch("wallets/$walletId/factors/$factorId",
        data: Japx.encode(tfaAttributes.toJson()));
  }
}
