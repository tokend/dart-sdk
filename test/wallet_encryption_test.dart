import 'package:dart_crypto_kit/crypto_cipher/aes256gcm.dart';
import 'package:dart_sdk/key_server/models/keychain_data.dart';
import 'package:dart_sdk/key_server/wallet_encryption.dart';
import 'package:dart_sdk/utils/extensions/random.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_sdk/utils/extensions/converting.dart';

void main() {
  test('encrypt single seed', () async {
    var seed = 'SA4HT5YMPW37JBXSRMKYGAI6RPTRTPSVT4A6PB4C6YNQEW5NV2I6JODU';
    var iv = getSecureRandomSeed(8);
    var key = getSecureRandomSeed(32);
    var encrypted = WalletEncryption.encryptSecretSeed(seed, iv, key);

    var decrypted =
        String.fromCharCodes(Aes256GCM(iv).decrypt(encrypted.cipherText, key));

    expect(
        "{\"seed\":\"SA4HT5YMPW37JBXSRMKYGAI6RPTRTPSVT4A6PB4C6YNQEW5NV2I6JODU\",\"seeds\":[\"SA4HT5YMPW37JBXSRMKYGAI6RPTRTPSVT4A6PB4C6YNQEW5NV2I6JODU\"]}",
        decrypted);
  });

  test('encrypt multiple seeds', () async {
    var seeds = List.of([
      'SD5GSVG5CJZWPWQ2HGY2KZTCABXY4AHG4PEHWCXCPEBJYXZB7ZPUKKNM',
      'SDZ6HECTO4UX7JXEISB7NIVD7AUALKKRXBPVDJ7KC64JZC4IOVUOEK6A'
    ]);
    var iv = getSecureRandomSeed(8);
    var key = getSecureRandomSeed(32);
    var encrypted = WalletEncryption.encryptSecretSeeds(seeds, iv, key);

    var decrypted =
        String.fromCharCodes(Aes256GCM(iv).decrypt(encrypted.cipherText, key));

    expect(
        "{\"seed\":\"SD5GSVG5CJZWPWQ2HGY2KZTCABXY4AHG4PEHWCXCPEBJYXZB7ZPUKKNM\",\"seeds\":[\"SD5GSVG5CJZWPWQ2HGY2KZTCABXY4AHG4PEHWCXCPEBJYXZB7ZPUKKNM\",\"SDZ6HECTO4UX7JXEISB7NIVD7AUALKKRXBPVDJ7KC64JZC4IOVUOEK6A\"]}",
        decrypted);
  });

  test('decrypt legacy', () async {
    var content = "{\"seed\":\"SA4HT5YMPW37JBXSRMKYGAI6RPTRTPSVT4A6PB4C6YNQEW5NV2I6JODU\"}";

    var iv = getSecureRandomSeed(8);
    var key = getSecureRandomSeed(32);
    var encrypted = Aes256GCM(iv).encrypt(content.toUInt8List(), key);

    var keychainData = KeychainData.fromRaw(iv, encrypted);
    var decryptedSeed = WalletEncryption.decryptSecretSeed(keychainData, key);
    expect(
        "SA4HT5YMPW37JBXSRMKYGAI6RPTRTPSVT4A6PB4C6YNQEW5NV2I6JODU",
        decryptedSeed);
  });

  test('decrypt multiple seeds', () async {
    var content = "{\"seeds\":[\"SD5GSVG5CJZWPWQ2HGY2KZTCABXY4AHG4PEHWCXCPEBJYXZB7ZPUKKNM\",\"SDZ6HECTO4UX7JXEISB7NIVD7AUALKKRXBPVDJ7KC64JZC4IOVUOEK6A\"]}";

    var iv = getSecureRandomSeed(8);
    var key = getSecureRandomSeed(32);
    var encrypted = Aes256GCM(iv).encrypt(content.toUInt8List(), key);

    var keychainData = KeychainData.fromRaw(iv, encrypted);
    var decryptedSeeds = WalletEncryption.decryptSecretSeeds(keychainData, key);
    expect(
        "SD5GSVG5CJZWPWQ2HGY2KZTCABXY4AHG4PEHWCXCPEBJYXZB7ZPUKKNM",
        decryptedSeeds[0]);

    expect(
        "SDZ6HECTO4UX7JXEISB7NIVD7AUALKKRXBPVDJ7KC64JZC4IOVUOEK6A",
        decryptedSeeds[1]);
  });

  test('decrypt legacy plus multiple seeds', () async {
    var content = "{\"seed\":\"SD5GSVG5CJZWPWQ2HGY2KZTCABXY4AHG4PEHWCXCPEBJYXZB7ZPUKKNM\",\"seeds\":[\"SD5GSVG5CJZWPWQ2HGY2KZTCABXY4AHG4PEHWCXCPEBJYXZB7ZPUKKNM\",\"SDZ6HECTO4UX7JXEISB7NIVD7AUALKKRXBPVDJ7KC64JZC4IOVUOEK6A\"]}";

    var iv = getSecureRandomSeed(8);
    var key = getSecureRandomSeed(32);
    var encrypted = Aes256GCM(iv).encrypt(content.toUInt8List(), key);

    var keychainData = KeychainData.fromRaw(iv, encrypted);
    var decryptedSeeds = WalletEncryption.decryptSecretSeeds(keychainData, key);
    expect(
        "SD5GSVG5CJZWPWQ2HGY2KZTCABXY4AHG4PEHWCXCPEBJYXZB7ZPUKKNM",
        decryptedSeeds[0]);

    expect(
        "SDZ6HECTO4UX7JXEISB7NIVD7AUALKKRXBPVDJ7KC64JZC4IOVUOEK6A",
        decryptedSeeds[1]);
  });

  //Test crushing with Unable to parse seed exception
  //is expected behavior
  test('decrypt malformed', () async {
    var content = "{\"nothing\":\"here\"\"]}";

    var iv = getSecureRandomSeed(8);
    var key = getSecureRandomSeed(32);
    var encrypted = Aes256GCM(iv).encrypt(content.toUInt8List(), key);

    var keychainData = KeychainData.fromRaw(iv, encrypted);
    WalletEncryption.decryptSecretSeeds(keychainData, key);
  });
}
