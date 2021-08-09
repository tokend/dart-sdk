import 'package:dart_sdk/api/wallets/wallets_api.dart';
import 'package:dart_sdk/key_server/key_server.dart';
import 'package:flutter_test/flutter_test.dart';

import 'util.dart';

void main() {
  test('sign in', () async {
    var email = 'testuser@gmail.com';
    var password = 'testuser@gmail.com';

    var api = Util.getApi();

    var keyServer = KeyServer(WalletsApi(api.serviceFactory.getService())); //TODO

    print("Attempt to sign up $email $password");

    var walletInfo = await keyServer.getWalletInfo(email, password);

    print(walletInfo.secretSeeds.first);
  });
}
