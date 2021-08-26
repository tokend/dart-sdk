import 'dart:convert';
import 'dart:core';

import 'package:dart_sdk/api/base/model/data_entity.dart';
import 'package:dart_sdk/key_server/models/encrypted_wallet_account.dart';
import 'package:dart_sdk/key_server/models/keychain_data.dart';
import 'package:dart_sdk/key_server/models/wallet_relation.dart';
import 'package:dart_sdk/utils/extensions/encoding.dart';

class WalletData {
  String type;
  String? id;
  WalletDataAttributes attributes;
  var relationships = {};

  static const TYPE_DEFAULT = "wallet";
  static const TYPE_RECOVERY = "recovery-wallet";

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'attributes': attributes.toJson(),
        'relationships': getRelationships(relationships)
      };

  Map<dynamic, dynamic> getRelationships(Map<dynamic, dynamic> map) {
    var res = {};
    map.forEach((key, value) {
      return res[key] = value.toJson();
    });

    return res;
  }

  WalletData.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        id = json['id'],
        attributes = WalletDataAttributes.fromJson((json['attributes'])),
        relationships = (json['relationships']);

  WalletData(this.type, this.id, this.attributes);

  WalletData.get(
      String type, String walletIdHex, EncryptedWalletAccount encryptedAccount,
      {String? verificationCode})
      : this.type = type,
        this.id = walletIdHex,
        this.attributes = WalletDataAttributes(
            encryptedAccount.accountId,
            encryptedAccount.email,
            encryptedAccount.encodedKeychainData,
            encryptedAccount.encodedSalt,
            false,
            verificationCode);

  addRelation(String name, WalletRelation relation) {
    relationships[name] = DataEntity(relation);
  }

  addArrayRelation(String name, Iterable<WalletRelation> relations) {
    relationships[name] = DataEntity(relations.toList());
  }

  List<WalletRelation> getFlattenRelationships() {
    var res = relationships.values.expand((relation) {
      var data = relation.data;
      if (data is Iterable) {
        return data.map((e) {
          return e as WalletRelation;
        });
      } else {
        return List.of([data as WalletRelation]);
      }
    });
    return res.toList();
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

  Map<String, dynamic> toJson() => {
        'account_id': accountId,
        'email': email,
        'keychain_data': encodedKeychainData,
        'salt': salt,
        'verified': isVerified,
        'verification_code': verificationCode,
      };

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
