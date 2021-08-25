import 'dart:convert';

import 'package:dart_sdk/key_server/models/wallet_data.dart';
import 'package:dart_sdk/key_server/models/wallet_relation.dart';

class WalletResourceBody {
  WalletData data;

  late Iterable<Object> included;

  WalletResourceBody(this.data) {
    included = data.getFlattenRelationships();
  }

  Map<String, dynamic> toJson() => {
    'data': data.toJson(),
    'included': getIncludes(included as List<WalletRelation>)
  };

  String getResourceBody() {
    return json.encode(Map.fromEntries(
        [MapEntry('data', data), MapEntry('included', included)]));
  }

  List<dynamic> getIncludes(List<WalletRelation> list) {
    var res = [];
    list.forEach((element) {
      res.add((element.toJson()));
    });
    return res;
  }
}
