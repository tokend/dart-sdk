import 'package:dart_sdk/api/base/params/paging_order.dart';
import 'package:dart_sdk/api/base/params/paging_params.dart';
import 'package:flutter/foundation.dart';

/// Backward-compatible pagination params for API V2.
class PagingParamsV2 extends PagingParams {
  String? cursor;
  int? limit;
  PagingOrder? order;

  static const QUERY_PARAM_PAGE_NUMBER = "page[number]";
  static const QUERY_PARAM_PAGE_CURSOR = "page[cursor]";
  static const QUERY_PARAM_LIMIT = "page[limit]";
  static const QUERY_PARAM_ORDER = "page[order]";

  PagingParamsV2(this.cursor, this.limit, this.order)
      : super(cursor, limit, order);

  @override
  Map<String, dynamic> map() {
    Map<String, dynamic> map = {};
    if (order != null) {
      map.addAll({QUERY_PARAM_ORDER: describeEnum(order!).toLowerCase()});
    }
    if (limit != null) {
      map.addAll({QUERY_PARAM_LIMIT: limit});
    }
    if (cursor != null && cursor != 'null') {
      map.addAll({
        "page": cursor,
        QUERY_PARAM_PAGE_NUMBER: cursor,
        QUERY_PARAM_PAGE_CURSOR: cursor
      });
    }
    return map;
  }
}

class Builder {
  PagingOrder? _order;
  int? _limit;
  String? _page;

  Builder withOrder(PagingOrder? order) {
    this._order = order;
    return this;
  }

  Builder withLimit(int? limit) {
    this._limit = limit;
    return this;
  }

  Builder withPage(String? page) {
    this._page = page;
    return this;
  }

  PagingParamsV2 build() {
    return PagingParamsV2(_page, _limit, _order);
  }
}
