import 'package:dio/dio.dart';

class TfaVerificationService {
  Dio dio;

  TfaVerificationService(this.dio);

  Future<Response> verifyTfaFactor(dynamic body, String walletId, int id) {
    return dio.put("wallets/$walletId/factors/$id/verification", data: body);
  }
}
