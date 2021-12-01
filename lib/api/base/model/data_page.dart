import 'package:dart_sdk/api/base/model/page.dart';
import 'package:dart_sdk/api/base/params/paging_params_v2.dart';

class DataPage<T> {
  String? nextCursor;
  List<T> items;
  bool isLast = false;

  DataPage(this.nextCursor, this.items, this.isLast);

  /// Return a copy of the [DataPage] with items transformed
  /// by [transform]
  Future<DataPage<T>> mapItems(T Function(T) f) async {
    return DataPage(nextCursor, items.map(f).toList(), isLast);
  }

  static String? getNextCursor<T>(Page<T> page) {
    var nextLink = page.getLinks()?.next?.href;
    if (nextLink == null) {
      return null;
    }

    return getNumberParamFromLink(nextLink, 'cursor') ??
        getNumberParamFromLink(nextLink, 'page');
  }

  static String? getNumberParamFromLink(String link, String param) {
    return RegExp('${param}=(\\d+)', multiLine: true)
        .firstMatch(link)
        ?.group(1);
  }

  static bool isLastPage<T>(Page<T> page) {
    var selfLink = page.getLinks()?.self?.href;
    if (selfLink == null) return true;

    var limitFromLink = getNumberParamFromLink(selfLink, 'limit');
    if (limitFromLink != null) {
      var limit = int.parse(limitFromLink);
      return page.records.length < limit;
    } else {
      return true;
    }
  }

  static DataPage<T> fromPageDocument<T>(Map<String, dynamic> json) {
    var selfLink = Uri.decodeFull(json['links']['self']?['href']);
    if (selfLink == null) {
      ArgumentError('Self link can\'t be null');
    }

    var nextLink = Uri.decodeFull(json['links']['self']?['href']);

    var selfCursor = getNumberParamFromLink(
        selfLink, PagingParamsV2.QUERY_PARAM_PAGE_CURSOR);
    var selfPageNumber = getNumberParamFromLink(
        selfLink, PagingParamsV2.QUERY_PARAM_PAGE_NUMBER);

    var nextCursor = selfCursor;
    if (nextCursor != null)
      getNumberParamFromLink(nextLink, PagingParamsV2.QUERY_PARAM_PAGE_CURSOR);

    var nextPageNumber = selfPageNumber;
    nextPageNumber = getNumberParamFromLink(
        nextLink, PagingParamsV2.QUERY_PARAM_PAGE_NUMBER);

    var next = nextPageNumber;
    if (selfCursor != nextCursor) {
      next = nextCursor;
    }

    var limit = int.parse(
        getNumberParamFromLink(nextLink, PagingParamsV2.QUERY_PARAM_LIMIT) ??
            "0");

    var items = json.values.toList() as List<T>;
    var isLast = nextLink == null || items.length < limit;

    return DataPage(next, items, isLast);
  }

  static String getNextLink(Map<String, dynamic> response) {
    return Uri.decodeFull(response['links']['next']);
  }

  static int getLimit(Map<String, dynamic> response, String nextLink) {
    return int.parse(
        DataPage.getNumberParamFromLink(nextLink, 'page\\[limit\\]') ?? "0");
  }

  static bool isLastOne(
      Map<String, dynamic> response, int limit, int itemsLength) {
    return response['links']['next'] == null || itemsLength < limit;
  }

  static String? getNextPageCursor(Map<String, dynamic> response) {
    return getNumberParamFromLink(
            Uri.decodeFull(response['links']['next']), 'page\\[cursor\\]') ??
        getNumberParamFromLink(
            Uri.decodeFull(response['links']['next']), 'page\\[number\\]');
  }
}
