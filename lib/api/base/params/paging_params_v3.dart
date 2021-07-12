import 'package:dart_sdk/api/base/params/paging_order.dart';
import 'package:dart_sdk/api/base/params/paging_params_v2.dart';

/// Paging params for JSONAPI cursor- or number-based paged collections.
///
/// @see withCursor
/// @see withNumber
/// @see Builder
class PagingParamsV3 extends PagingParamsV2 {
  bool numberInsteadOfCursor;

  PagingParamsV3._(
      PagingOrder? order, String? page, int? limit, this.numberInsteadOfCursor)
      : super(page, limit, order);

  @override
  Map<String, dynamic> map() {
    Map<String, dynamic> map = {};
    if (cursor != null) {
      if (numberInsteadOfCursor) {
        map.addAll({PagingParamsV2.QUERY_PARAM_PAGE_NUMBER: cursor});
      } else {
        map.addAll({PagingParamsV2.QUERY_PARAM_PAGE_CURSOR: cursor});
      }
    }
    if (order != null) {
      map.addAll({PagingParamsV2.QUERY_PARAM_ORDER: order});
    }
    if (limit != null) {
      map.addAll({PagingParamsV2.QUERY_PARAM_LIMIT: limit});
    }
    return map;
  }

  static PagingParamsV3 withCursor(
      String? cursor, int? limit, PagingOrder? order) {
    return PagingParamsV3._(order, cursor, limit, false);
  }

  static PagingParamsV3 wthNumber(
      String? number, int? limit, PagingOrder? order) {
    return PagingParamsV3._(order, number, limit, true);
  }
}

class Builder {
  PagingOrder? _order;
  int? _limit;
  String? _page;
  bool _numberInsteadOfCursor = false;

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

  Builder withNumberInsteadOfCursor() {
    this._numberInsteadOfCursor = true;
    return this;
  }

  PagingParamsV3 build() {
    return PagingParamsV3._(_order, _page, _limit, _numberInsteadOfCursor);
  }
}
