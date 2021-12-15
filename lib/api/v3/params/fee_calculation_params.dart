import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:decimal/decimal.dart';

class FeeCalculationParams {
  String asset;
  FeeType feeType;
  int subtype;
  Decimal amount;

  FeeCalculationParams(this.asset, this.feeType, this.subtype, this.amount);

  Map<String, dynamic> map() {
    return Map.fromEntries([
      MapEntry('asset', asset),
      MapEntry('fee_type', feeType.value),
      MapEntry('subtype', subtype),
      MapEntry('amount', amount.toString()),
    ]);
  }
}
