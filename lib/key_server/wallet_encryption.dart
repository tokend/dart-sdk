import 'dart:convert';

import 'package:dart_crypto_kit/crypto_cipher/aes256gcm.dart';
import 'package:dart_sdk/key_server/models/encrypted_wallet_account.dart';
import 'package:dart_sdk/key_server/models/keychain_data.dart';
import 'package:dart_sdk/key_server/seedreader/keychain_data_seeds_array_reader.dart';
import 'package:dart_sdk/key_server/seedreader/keychain_data_single_seed_reader.dart';
import 'package:dart_wallet/account.dart';
import 'package:dart_wallet/extensions/erase_extensions.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:secure_random/secure_random.dart';

class WalletEncryption {
  static const IV_LENGTH = 12;

  /// Wraps given secret seeds into JSON object
  /// and encrypts it with given key
  ///
  /// [seeds] secret seeds of the [Account]. The first will be used
  /// for legacy format ("seed" attribute)
  /// [iv] non-empty cipher initialization vector
  /// [walletEncryptionKey] 32 bytes encryption key
  ///
  /// See [WalletKeyDerivation.deriveWalletEncryptionKey]
  /// See [Account.secretSeed]
  /// See [Aes256GCM]
  static KeychainData encryptSecretSeeds(
      List<String> seeds, Uint8List iv, Uint8List walletEncryptionKey) {
    var primarySeed = seeds.first;
    var jsonStart = '{"seed":"';
    var jsonMiddle = '","seeds":[';
    var jsonEnd = ']}';

    var seedsBuffer = "";
    for (int i = 0; i < seeds.length; i++) {
      seedsBuffer += '"';
      seedsBuffer += seeds[i];
      seedsBuffer += '"';

      if (i != seeds.length - 1) {
        seedsBuffer += ',';
      }
    }

    var jsonBuffer =
        jsonStart + primarySeed + jsonMiddle + seedsBuffer + jsonEnd;

    var jsonBytes = Uint8List.fromList(utf8.encode(jsonBuffer));

    var encrypted = Aes256GCM(iv).encrypt(jsonBytes, walletEncryptionKey);
    jsonBytes.erase();
    return KeychainData.fromRaw(iv, encrypted);
  }

  /// Wraps given secret seed into JSON object
  /// and encrypts it with given key
  ///
  /// [seed] secret seed of the [Account]
  /// [iv] non-empty cipher initialization vector
  /// [walletEncryptionKey] 32 bytes encryption key
  ///
  /// See [WalletKeyDerivation.deriveWalletEncryptionKey]
  /// See [Account.secretSeed]
  /// See [Aes256GCM]
  static KeychainData encryptSecretSeed(
      String seed, Uint8List iv, Uint8List walletEncryptionKey) {
    return encryptSecretSeeds(List.of([seed]), iv, walletEncryptionKey);
  }

  static List<String> decryptSecretSeeds(
      KeychainData keychainData, Uint8List walletEncryptionKey) {
    var iv = keychainData.iv;
    var cipherText = keychainData.cipherText;

    var seedJsonBytes = Aes256GCM(iv).decrypt(cipherText, walletEncryptionKey);
    var seedJsonCharBuffer = utf8.decode(seedJsonBytes);

    var arrayParser = KeychainDataSeedsArrayReader()..run(seedJsonCharBuffer);
    var singleParser = KeychainDataSingleSeedReader()..run(seedJsonCharBuffer);

    if (arrayParser.reedSeeds.isNotEmpty)
      return arrayParser.reedSeeds;
    else if (singleParser.reedSeed != null) {
      return List.of([singleParser.reedSeed!]);
    } else {
      throw Exception("Unable to parse seed");
    }
  }

  /// Decrypts single secret seed wrapped into JSON object with given key
  ///
  /// See WalletKeyDerivation.deriveWalletEncryptionKey
  /// See encryptSecretSeed
  static String decryptSecretSeed(
      KeychainData keychainData, Uint8List walletEncryptionKey) {
    return decryptSecretSeeds(keychainData, walletEncryptionKey).first;
  }

  /// Encrypts given account
  ///
  /// [email] wallet email
  /// [account] [Account] to encrypt
  /// [walletEncryptionKey] 32 bytes encryption key
  /// [keyDerivationSalt] KDF salt used for [walletEncryptionKey] derivation
  ///
  /// See [WalletKeyDerivation.deriveWalletEncryptionKey]
  /// See [Aes256GCM]
  static EncryptedWalletAccount encryptAccount(String email, Account account,
      Uint8List walletEncryptionKey, Uint8List keyDerivationSalt) {
    return encryptAccounts(
        email, List.of([account]), walletEncryptionKey, keyDerivationSalt);
  }

  /// Encrypts given account assuming that first account is the root one
  ///
  /// [email] wallet email
  /// [accounts] accounts to encrypt in specified order
  /// [walletEncryptionKey] 32 bytes encryption key
  /// [keyDerivationSalt] KDF salt used for [walletEncryptionKey] derivation
  ///
  /// See [WalletKeyDerivation.deriveWalletEncryptionKey]
  /// See [Aes256GCM]
  static encryptAccounts(String email, List<Account> accounts,
      Uint8List walletEncryptionKey, Uint8List keyDerivationSalt) {
    var sourceRandom = SecureRandom();
    String s = sourceRandom.nextString(length: IV_LENGTH);
    var iv = Uint8List.fromList(s.codeUnits);

    var seeds = accounts.map((account) {
      if (account.secretSeed == null) {
        throw ArgumentError('Account $account has no secret seed');
      } else {
        return account.secretSeed!;
      }
    }).toList();

    Account mainAccount;
    if (accounts.isEmpty) {
      throw ArgumentError('There must be at least one account');
    } else {
      mainAccount = accounts.first;
    }

    var encryptedSeedsKeychainData =
        encryptSecretSeeds(seeds, iv, walletEncryptionKey);

    //TODO find out a way to erase seeds

    return EncryptedWalletAccount.get(mainAccount.accountId, email,
        keyDerivationSalt, encryptedSeedsKeychainData);
  }
}
