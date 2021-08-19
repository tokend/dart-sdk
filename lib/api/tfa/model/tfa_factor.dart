import 'package:flutter/foundation.dart';

class TfaFactor {
  final int id;
  final String type;
  final String priority;

  TfaFactor(this.id, this.type, this.priority);

  TfaFactor.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        priority = json['priority'];
}

enum TfaFactorType {
  TOTP,
  PASSWORD,
  EMAIL,
  PHONE,
  TELEGRAM,
  UNKNOWN,
}

extension TfaFactorExt on String {
  TfaFactorType fromLiteral() {
    var type = TfaFactorType.UNKNOWN;
    TfaFactorType.values.forEach((type) {
      if (describeEnum(type) == this) {
        type = type;
      }
    });

    return type;
  }
}
