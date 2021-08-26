import 'dart:convert';

import 'package:dart_sdk/api/base/model/error_body.dart';
import 'package:dart_sdk/api/custom/custom_requests_api.dart';
import 'package:dart_sdk/api/transactions/model/submit_transaction_response.dart';
import 'package:dart_sdk/api/transactions/model/transaction_failed_exception.dart';
import 'package:dart_sdk/api/transactions/model/transaction_resource.dart';
import 'package:dart_wallet/transaction.dart' as Transaction;
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:dio/dio.dart';

class TransactionsApi {
  final CustomRequestsApi _service;

  TransactionsApi(this._service);

  /// @return transaction by it's ID
  Future<TransactionResource> getById(String id) async {
    var response = await _service.get("v3/transactions/$id");
    return TransactionResource.fromJson(response);
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
  Future<SubmitTransactionResponse?> submitTransaction(
          Transaction.Transaction transaction, bool waitForIngest) =>
      submitTransactionEnvelope(transaction.getEnvelope(), waitForIngest);

  /// Submits given transaction envelope
  Future<SubmitTransactionResponse?> submitTransactionEnvelope(
          TransactionEnvelope transactionEnvelope, bool waitForIngest) =>
      submit(transactionEnvelope.toBase64(), waitForIngest);

  /// Submits given transaction envelope
  Future<SubmitTransactionResponse?> submit(
      String envelopeBase64, bool waitForIngest) async {
    try {
      var responseAttributes = (await _service.post("v3/transactions", body: {
        'tx': envelopeBase64,
        'wait_for_ingest': waitForIngest
      }))['data']['attributes'];
      return SubmitTransactionResponse(
          null,
          responseAttributes['ledger_sequence'],
          responseAttributes['created_at'],
          responseAttributes['hash'],
          responseAttributes['envelope_xdr'],
          responseAttributes['result_xdr'],
          responseAttributes['result_meta_xdr']);
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 400:
          var exception = _getResponseFromHttpException(e.response);
          throw exception != null ? TransactionFailedException(exception) : e;
        default:
          throw e;
      }
    }
  }
}
