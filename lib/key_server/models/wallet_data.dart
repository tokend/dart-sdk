import 'dart:convert';
import 'dart:core';

import 'package:dart_sdk/api/base/model/data_entity.dart';
import 'package:dart_sdk/key_server/models/encrypted_wallet_account.dart';
import 'package:dart_sdk/key_server/models/keychain_data.dart';
import 'package:dart_sdk/key_server/models/wallet_relation.dart';
import 'package:dart_sdk/utils/extensions/encoding.dart';

class WalletData {
  String type;
  String id;
  WalletDataAttributes attributes;
  var relationships = Map<String, DataEntity<dynamic>>.fromEntries([]);

  static const TYPE_DEFAULT = "wallet";
  static const TYPE_RECOVERY = "recovery-wallet";

  WalletData.fromJson(Map<String, dynamic> json)
      : type = json['data']['type'],
        id = json['data']['id'],
        attributes = WalletDataAttributes.fromJson((json['data']['attributes']));
        //relationships = (json['data']['relationships']);

  WalletData(this.type, this.id, this.attributes);

  WalletData.get(
      String type, String walletIdHex, EncryptedWalletAccount encryptedAccount,
      {String? verificationCode})
      : this.type = type,
        this.id = walletIdHex,
        this.attributes = WalletDataAttributes(
            encryptedAccount.accountId,
            encryptedAccount.email,
            encryptedAccount.encodedSalt,
            encryptedAccount.encodedKeychainData,
            false,
            verificationCode);

  addRelation(String name, WalletRelation relation) {
    relationships[name] = DataEntity(relation);
  }

  addArrayRelation(String name, Iterable<WalletRelation> relations) {
    relationships[name] = DataEntity(relations);
  }

  List<WalletRelation> getFlattenRelationships() {
    return relationships.values.expand((relation) {
      var data = relation.data;
      if (data is Iterable) {
        return data.map((e) => {e as WalletRelation});
      } else {
        return List.of([data as WalletRelation]);
      }
    }) as List<WalletRelation>;
  }
}

class WalletDataAttributes {
  String accountId;
  String email;
  String encodedKeychainData;
  String salt;
  bool isVerified;
  String? verificationCode;

  WalletDataAttributes(this.accountId, this.email, this.encodedKeychainData,
      this.salt, this.isVerified, this.verificationCode);

  WalletDataAttributes.fromJson(Map<String, dynamic> json)
      : accountId = json['account_id'],
        email = json['email'],
        encodedKeychainData = json['keychain_data'],
        salt = json['salt'],
        isVerified = json['verified'],
        verificationCode = json['verification_code'];

  KeychainData get keychainData => KeychainData.getFromJson(
      json.decode(String.fromCharCodes(encodedKeychainData.decodeBase64())));
}
