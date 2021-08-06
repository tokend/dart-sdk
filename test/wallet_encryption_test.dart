
import 'package:dart_sdk/key_server/wallet_encryption.dart';
import 'package:dart_sdk/utils/extensions/random.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  test('encrypt single seed', () async {
    var seed = 'SA4HT5YMPW37JBXSRMKYGAI6RPTRTPSVT4A6PB4C6YNQEW5NV2I6JODU';
    var iv = getSecureRandomSeed(8);
    var key = getSecureRandomSeed(32);
    var encrypted = WalletEncryption.encryptSecretSeed(seed, iv, key);

    print(encrypted.iv);
  });
}
