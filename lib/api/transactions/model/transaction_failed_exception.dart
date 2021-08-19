import 'package:dart_sdk/api/transactions/model/submit_transaction_response.dart';

class TransactionFailedException implements Exception {
  final SubmitTransactionResponse submitTransactionResponse;

  TransactionFailedException(this.submitTransactionResponse);

  String get transactionResultCode =>
      submitTransactionResponse.extras!.resultCodes.transactionResultCode;

  List<String> get operationResultCodes =>
      submitTransactionResponse.extras!.resultCodes.operationsResultCodes;

  String? get firstOperationResultCode =>
      operationResultCodes.firstWhere((element) => element != "op_success");

  static const TX_FAILED = "tx_failed";
  static const TX_BAD_AUTH = "tx_bad_auth_extra";
  static const TX_NO_ROLE_PERMISSION = "tx_no_role_permission";
  static const OP_LIMITS_EXCEEDED = "op_limits_exceeded";
  static const OP_INSUFFICIENT_BALANCE = "op_underfunded";
  static const OP_INVALID_AMOUNT = "op_invalid_amount";
  static const OP_MALFORMED = "op_malformed";
  static const OP_ACCOUNT_BLOCKED = "op_account_blocked";
  static const OP_INVALID_FEE = "op_fee_mismatched";
  static const OP_NOT_ALLOWED = "op_not_allowed";
  static const OP_HARD_CAP_VIOLATION = "op_order_violates_hard_cap";
  static const OP_INACTIVE_SALE = "op_sale_is_not_active";
  static const OP_ENDED_SALE = "op_sale_already_ended";
  static const OP_OFFER_CROSS_SELF = "op_cross_self";
  static const OP_NO_AVAILABLE_EXTERNAL_ACCOUNTS = "op_no_available_id";
  static const OP_AMOUNT_LESS_THEN_DEST_FEE =
      "op_payment_amount_is_less_than_dest_fee";
  static const OP_REQUIRES_KYC = "op_requires_kyc";
  static const OP_NOT_FOUND = "op_not_found";
  static const OP_NO_ROLE_PERMISSION = "op_no_role_permission";
  static const OP_NO_ENTRY = "op_no_entry";
}
