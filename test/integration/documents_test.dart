import 'package:dart_sdk/api/documents/documents_api.dart';
import 'package:dart_sdk/api/documents/model/document_type.dart';
import 'package:dart_sdk/api/wallets/wallets_api.dart';
import 'package:dart_sdk/key_server/key_server.dart';
import 'package:dart_sdk/signing/account_request_signer.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config.dart';
import '../util.dart';

void main() {
  test('upload document', () async {
    var email = 'testuser@gmail.com';
    var password = 'testuser@gmail.com';

    var api = Util.getApi();
    var keyServer = KeyServer(WalletsApi(api.serviceFactory.getService()));

    print('Attempt to sign up $email $password');
    var walletInfo = await keyServer.getWalletInfo(email, password);

    var adminAccount = await Config.ADMIN_ACCOUNT;
    var signedApi = Util.getSignedApi(adminAccount, url: api.rootUrl);

    var documentApi = DocumentsApi(signedApi.serviceFactory
        .getService(requestSigner: AccountRequestSigner(adminAccount)));
    var fileName = "test.txt";
    var document = Uint8List.fromList("Hello World".codeUnits);
    var contentType = "text/plain";

    var uploadPolicy = await documentApi.requestUpload(
        walletInfo.accountId, DocumentType.GENERAL_PRIVATE, contentType);
    //Japx.decode(jsonDecode(uploadPolicy));
    print(uploadPolicy);
  });
}
