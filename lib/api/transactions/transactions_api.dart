import 'package:dio/dio.dart';

class TransactionsApi {
  final Dio _dio;

  TransactionsApi(this._dio);

  /// @return transaction by it's ID
  Future<void> getById(String id) {
    return _dio.get("v3/transactions/$id");
  }
}
