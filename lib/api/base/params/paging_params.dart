import 'package:dart_sdk/api/base/params/paging_order.dart';
import 'package:dart_sdk/api/base/params/paging_params_holder.dart';
import 'package:dart_sdk/api/base/params/query_params.dart';

class PagingParams extends QueryParams implements PagingParamsHolder {
  PagingParams(String? cursor, int? limit, PagingOrder? order) {
    this.cursor = cursor;
    this.limit = limit;
    this.order = order;
  }

  @override
  String? cursor;

  @override
  int? limit;

  @override
  PagingOrder? order;

  @override
  Map<String, dynamic> map() {
    Map<String, dynamic> map = {};
    if (order != null) {
      map.addAll({"order": order});
    }
    if (limit != null) {
      map.addAll({"limit": limit});
    }
    if (cursor != null) {
      map.addAll({"cursor": cursor});
    }
    return map;
  }
}
