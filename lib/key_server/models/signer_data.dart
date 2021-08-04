import 'package:dart_wallet/xdr/xdr_types.dart';

/// Account signer data holder
class SignerData {
  late String id;
  late UINT32 identity;
  late UINT32 weight;
  late UINT64 roleId;
  late String? detailsJson;

  static const DEFAULT_SIGNER_IDENTITY = 0;
  static const DEFAULT_SIGNER_WEIGHT = 1000;

  SignerData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        identity = json['identity'],
        weight = json['weight'],
        roleId = json['role_id'],
        detailsJson = json['details'];

  SignerData(String id, UINT64 roleId) {
    this.id = id;
    this.roleId = roleId;
    identity = DEFAULT_SIGNER_IDENTITY;
    weight = DEFAULT_SIGNER_WEIGHT;
    detailsJson = null;
  }
}
