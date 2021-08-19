import 'package:dart_sdk/api/transactions/model/transaction_failed_exception.dart';
import 'package:dart_sdk/utils/extensions/horizon_state_resource.dart';
import 'package:dart_wallet/transaction_builder.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config.dart';
import '../util.dart';

void main() {
  test("transactionTest", () async {
    var api = Util.getLocalApi();
    var netParams =
        await api.info.getSystemInfo().then((value) => value.toNetworkParams());

    print(netParams);
    var account = await Config.ADMIN_ACCOUNT;
    var tx = await TransactionBuilder.FromPubKey(netParams, account.accountId)
        .addOperation(OperationBodyCreateAtomicSwapBidRequest(
            CreateAtomicSwapBidRequestOp(
                CreateAtomicSwapBidRequest(Int64(404), Int64(1), "OLE", "{}",
                    CreateAtomicSwapBidRequestExtEmptyVersion()),
                CreateAtomicSwapBidRequestOpExtEmptyVersion())))
        .addSigner(account)
        .build();

    try {
      var response = await api.transactions.submitTransaction(tx, false);
    } on TransactionFailedException catch (e) {
      expect(e.transactionResultCode, TransactionFailedException.TX_FAILED);
      expect(
          e.firstOperationResultCode, TransactionFailedException.OP_NO_ENTRY);
    }
  });
}
