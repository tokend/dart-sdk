import 'dart:convert';

import 'package:dart_sdk/key_server/models/wallet_data.dart';

class WalletResourceBody {
  WalletData data;

  late Iterable<Object> included;

  WalletResourceBody(this.data) {
    included = data.getFlattenRelationships();
  }

  String getResourceBody() {
    return json.encode(Map.fromEntries(
        [MapEntry('data', data), MapEntry('included', included)]));
  }
}
