import 'package:dio/dio.dart';

class TfaVerificationService {
  Dio _dio;

  TfaVerificationService(this._dio);

  Future<Response> verifyTfaFactor(dynamic body, String walletId, int id) {
    return _dio.put("wallets/$walletId/factors/$id/verification", data: body);
  }
}
