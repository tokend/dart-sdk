import 'package:flutter/foundation.dart';

class TfaFactor {
  final int id;
  final String type;
  final int priority;

  TfaFactor(this.id, this.type, this.priority);

  TfaFactor.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        type = json['type'],
        priority = json['attributes']['priority'];
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
    TfaFactorType.values.forEach((t) {
      if (describeEnum(t).toUpperCase() == this.toUpperCase()) {
        type = t;
      }
    });

    return type;
  }
}
