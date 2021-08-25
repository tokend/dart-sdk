import 'package:dart_sdk/key_server/models/wallet_relation.dart';

/// Represents request body with [T] data.
class DataEntity<T> {
  T data;

  DataEntity(this.data);

  DataEntity.fromJson(Map<String, dynamic> json) : data = json['data'];

  //TODO
  Map<String, dynamic> toJson() => {'data': (data)};
}

/// Represents request body with [T] data.
class WalletRelationDataEntity<T> {
  WalletRelation data;

  WalletRelationDataEntity(this.data);

  WalletRelationDataEntity.fromJson(Map<String, dynamic> json)
      : data = json['data'];

  //TODO
  Map<dynamic, dynamic> toJson() => {'data': data.toJson()};
}

/// Represents request body with [T] data.
class WalletArrayRelationDataEntity<T> {
  var data = <WalletRelation>[];

  WalletArrayRelationDataEntity(this.data);

  WalletArrayRelationDataEntity.fromJson(Map<String, dynamic> json)
      : data = json['data'];

  //TODO
  Map<dynamic, dynamic> toJson() => {'data': getData(data)};

  List<Map<dynamic, dynamic>> getData(List<WalletRelation> d) {
    var res = <Map<dynamic, dynamic>>[];

    d.forEach((element) {
      res.add(element.toJson());
    });
    return res;
  }
}