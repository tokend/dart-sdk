import 'package:dart_sdk/api/documents/model/document_type.dart';
import 'package:dart_sdk/api/wallets/wallets_api.dart';
import 'package:dart_sdk/key_server/key_server.dart';
import 'package:dart_wallet/account.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util.dart';

void main() {
  test('upload document', () async {
    var email = 'testuser@gmail.com';
    var password = 'testuser@gmail.com';

    var api = Util.getApi();
    var keyServer = KeyServer(WalletsApi(api.serviceFactory.getService()));

    print('Attempt to sign up $email $password');
    var walletInfo = await keyServer.getWalletInfo(email, password);

    var account = await Account.fromSecretSeed(walletInfo.secretSeeds.first);
    var signedApi = Util.getSignedApi(account, url: api.rootUrl);

    var fileName = "test.txt";
    var document = Uint8List.fromList("Hello World".codeUnits);
    var contentType = "text/plain";

    var uploadPolicy = await signedApi.documents.requestUpload(
        walletInfo.accountId, DocumentType.GENERAL_PRIVATE, contentType);

    var uploadedFile = await api.documents
        .upload(uploadPolicy, contentType, fileName, document);

    var key = uploadPolicy['data']['key'];
    if (key == null) {
      AssertionError(
          "Upload policy has no key, can't check if upload was successful");
      return;
    }

    expect(key, uploadedFile.key);
    expect(contentType, uploadedFile.mimeType);
    expect(fileName, uploadedFile.name);

    var uploadedUrl = await signedApi.documents.getUrl(uploadedFile.key);

    var dio = Dio(BaseOptions(responseType: ResponseType.bytes));
    var downloadedDocument = Uint8List.fromList(
        await (dio.get(uploadedUrl).then((response) => response.data)));

    expect(downloadedDocument, document);
  });
}
