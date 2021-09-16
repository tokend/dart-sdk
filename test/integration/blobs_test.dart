import 'dart:math';

import 'package:dart_sdk/api/blobs/model/blob.dart';
import 'package:dart_sdk/api/blobs/model/blob_type.dart';
import 'package:dart_sdk/key_server/key_server.dart';
import 'package:dart_wallet/account.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util.dart';

void main() {
  test("create blob", () async {
    var email =
        'createBlob${Random.secure().nextInt(Int32.MAX_VALUE.toInt())}@gmail.com';
    var password = 'qwe123';

    var api = Util.getApi();

    var keyServer = KeyServer(api.wallets);

    var newAccount = await Account.random();

    var result = await keyServer.createAndSaveWallet(
        email, password, api.v3.keyValue, newAccount);

    email = result.walletData.attributes.email;

    var currentWalletInfo = await keyServer.getWalletInfo(email, password);

    var signedApi = Util.getSignedApi(result.rootAccount, url: api.rootUrl);

    var content = 'Hello World';
    var blob = await signedApi.blobs.create(
      Blob.fromContent(BlobType.ALPHA, content),
      ownerAccountId: currentWalletInfo.accountId,
    );

    var downloadedBlob = await signedApi.blobs.getBlob(blob.id);

    expect(content, downloadedBlob.attributes.value);
  });
}
