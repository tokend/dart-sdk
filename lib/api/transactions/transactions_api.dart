import 'dart:convert';

import 'package:dart_sdk/api/base/model/error_body.dart';
import 'package:dart_sdk/api/transactions/model/submit_transaction_response.dart';
import 'package:dart_wallet/transaction.dart' as Transaction;
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:dio/dio.dart';

class TransactionsApi {
  final Dio _dio;

  TransactionsApi(this._dio);

  /// @return transaction by it's ID
  Future<void> getById(String id) {
    return _dio.get("v3/transactions/$id");
  }

  SubmitTransactionResponse? _getResponseFromHttpException(
      Response<dynamic>? response) {
    if (response != null) {
      var error = ErrorBody.fromJson(jsonDecode(response.data)).firstOrNull;
      if (error != null) {
        var meta = error.meta;
        if (meta != null) {
          meta.addAll({"envelope_xdr": meta['envelope'].toString()});
        } else {
          return null;
        }
        var extras = Extras.fromJson(meta);
        return SubmitTransactionResponse(extras, null, null, null,
            extras.envelopeXdr, extras.resultXdr, null);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  /// Submits given transaction
  void submitTransaction(
          Transaction.Transaction transaction, bool waitForIngest) =>
      submitTransactionEnvelope(transaction.getEnvelope(), waitForIngest);

  /// Submits given transaction envelope
  void submitTransactionEnvelope(
          TransactionEnvelope transactionEnvelope, bool waitForIngest) =>
      submit(transactionEnvelope.toBase64(), waitForIngest);

  /// Submits given transaction envelope
  void submit(String envelopeBase64, bool waitForIngest) async {
    try {
      var response = await _dio.post("v3/transactions",
          data: {'tx': envelopeBase64, 'wait_for_ingest': waitForIngest});
      SubmitTransactionResponse.fromJson(jsonDecode(response.data));
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          var response = _getResponseFromHttpException(e.response);
          break;
        default:
          throw e;
      }
    }
  }
}
