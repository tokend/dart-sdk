import 'package:dart_sdk/api/transactions/model/transaction_failed_exception.dart';
import 'package:dart_sdk/utils/extensions/encoding.dart';
import 'package:dart_sdk/utils/extensions/horizon_state_resource.dart';
import 'package:dart_wallet/account.dart';
import 'package:dart_wallet/public_key_factory.dart';
import 'package:dart_wallet/transaction_builder.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config.dart';
import '../util.dart';

void main() {
  test("error submission", () async {
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

  test("submit", () async {
    var api = Util.getLocalApi();
    var netParams =
        await api.info.getSystemInfo().then((value) => value.toNetworkParams());
    var account = await Config.ADMIN_ACCOUNT;

    var accountRoles = (await api.getService().get('v3/account_roles'))['data'];
    var accountRole = (accountRoles as List<dynamic>).first['id'];

    var signerRoles = (await api.getService().get('v3/signer_roles'))['data'];
    var signerRole = (signerRoles as List<dynamic>).first['id'];

    var randomAccount = await Account.random();

    var tx = await TransactionBuilder.FromPubKey(netParams, account.accountId)
        .addOperation(OperationBodyCreateAccount(CreateAccountOp(
            PublicKeyFactory.fromAccountId(randomAccount.accountId),
            null,
            Int64(int.parse(accountRole)),
            [
              UpdateSignerData(
                  PublicKeyFactory.fromAccountId(account.accountId),
                  Int64(int.parse(signerRole)),
                  1000,
                  0,
                  "{}",
                  EmptyExtEmptyVersion())
            ],
            CreateAccountOpExtEmptyVersion())))
        .addSigner(account)
        .build();

    try {
      var response = await api.transactions.submitTransaction(tx, false);
      expect(response?.isSuccess, true);
      expect(response?.getEnvelopeXdr() != null, true);
      expect(response?.resultMetaXdr != null, true);
      expect(tx.hash().encodeHexString() == response?.hash, true);
    } on TransactionFailedException catch (e) {
      print(e);
    }
  });
}
