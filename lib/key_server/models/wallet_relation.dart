import 'package:dart_sdk/key_server/models/encrypted_wallet_account.dart';
import 'package:dart_sdk/key_server/models/signer_data.dart';
import 'package:dart_wallet/transaction.dart';

class WalletRelation {
  String id;
  String type;
  var attributes;

  WalletRelation(this.id, this.type, this.attributes);

  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'type': type,
        'attributes': getAttributes(attributes),
      };

  Map<dynamic, dynamic>? getAttributes(dynamic attributes) {
    if (attributes is Map<String, String>)
      return attributes;
    else
      return attributes?.toJson();
  }

  WalletRelation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        attributes = json['attributes'];

  static password(EncryptedWalletAccount encryptedPasswordAccount) {
    return WalletRelation('password_id', 'password', encryptedPasswordAccount);
  }

  static kdf(int kdfVersion) {
    return WalletRelation(kdfVersion.toString(), 'kdf', null);
  }

  static transaction(Transaction transaction) {
    return WalletRelation('tx_id', 'transaction',
        {'envelope': transaction.getEnvelope().toBase64()});
  }

  static signer(SignerData signerData) {
    return WalletRelation(signerData.id, 'signer', signerData);
  }
}
