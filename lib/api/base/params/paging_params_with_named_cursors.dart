import 'package:dart_sdk/api/base/params/paging_order.dart';
import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/base/params/query_params.dart';

/// Query params for pagination over a joined collection
/// with multiple named cursors.
///
/// @see cursorsQueryParams
/// @see getCursorsFromUrl
class PagingParamsWithNamedCursors implements QueryParams {
  PagingOrder? order;
  int? limit;
  Map<String, String?>? cursorsByNames;
  late Map<String, String> _cursorsQueryParams;

  PagingParamsWithNamedCursors(
      PagingOrder? order, int? limit, Map<String, String?>? cursorsByNames) {
    this.order = order;
    this.limit = limit;
    this.cursorsByNames = cursorsByNames;

    var tmp = cursorsByNames
      ?..removeWhere((key, value) => value == null || value.isEmpty)
      ..map((key, value) => MapEntry(key, value))
      ..map((key, value) => MapEntry("page[cursor.$key]", value));

    if (tmp == null) {
      tmp = {};
    }

    this._cursorsQueryParams = tmp as Map<String, String>;
  }

  @override
  Map<String, dynamic> map() {
    Map<String, dynamic> map = {};
    if (limit != null) {
      map.addAll({PagingParamsV2.QUERY_PARAM_LIMIT: limit});
    }
    if (order != null) {
      map.addAll({PagingParamsV2.QUERY_PARAM_ORDER: order});
    }
    map.addAll(_cursorsQueryParams);
    return map;
  }

  static var CURSORS_REGEX = RegExp(r"page\[cursor\.(.+?)]=(.+?)(?:&|\$)");

  static Map<String, String> getCursorsFromUrl(String url) {
    Map<String, String>? resultMap;

    var results = CURSORS_REGEX.allMatches(url);
    for (RegExpMatch result in results) {
      if (result.groupCount >= 2) {
        if (result[1] != null && result[2] != null) {
          return {result[1]!: result[2]!};
        }
      }
    }
    return {};
  }
}
