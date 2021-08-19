import 'package:dart_wallet/xdr/xdr_types.dart';

/// Account signer data holder
class SignerData {
  late String id;
  late UINT32 identity;
  late UINT32 weight;
  late int roleId;
  late String? detailsJson;

  static const DEFAULT_SIGNER_IDENTITY = 0;
  static const DEFAULT_SIGNER_WEIGHT = 1000;

  Map<String, dynamic> toJson() => {
    'type': id,
    'identity': identity,
    'weight': weight,
    'role_id': roleId,
    'details': detailsJson,
  };

  SignerData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        identity = json['identity'],
        weight = json['weight'],
        roleId = json['role_id'],
        detailsJson = json['details'];

  SignerData.primary(
      this.id, this.identity, this.weight, this.roleId, this.detailsJson);

  SignerData(String id, int roleId) {
    this.id = id;
    this.roleId = (roleId);
    identity = DEFAULT_SIGNER_IDENTITY;
    weight = DEFAULT_SIGNER_WEIGHT;
    detailsJson = null;
  }
}
