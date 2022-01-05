import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/v3/base/json_api_query_params.dart'
    as jsonApiQueryParams;
import 'package:dart_sdk/api/v3/base/page_query_params.dart' as pagingQuery;

class MatchesPageParams extends pagingQuery.PageQueryParams {
  String? baseAsset;
  String? quoteAsset;
  String? orderBookId;

  MatchesPageParams(
      {this.baseAsset,
      this.quoteAsset,
      this.orderBookId,
      PagingParamsV2? pagingParams,
      List<String>? include})
      : super(pagingParams, include);

  @override
  Map<String, dynamic> map() {
    return super.map()
      ..putFilter('base_asset', baseAsset)
      ..putFilter('quote_asset', quoteAsset)
      ..putFilter('order_book', orderBookId);
  }
}

class MatchesPageParamsBuilder extends pagingQuery.Builder {
  String? baseAsset;
  String? quoteAsset;
  String? orderBookId;

  withBaseAsset(String baseAsset) {
    this.baseAsset = baseAsset;
  }

  withQuoteAsset(String quoteAsset) {
    this.quoteAsset = quoteAsset;
  }

  withOrderBookId(String orderBookId) {
    this.orderBookId = orderBookId;
  }

  @override
  jsonApiQueryParams.Builder withInclude(List<String>? include) {
    return super.withInclude(include);
  }

  @override
  withPagingParams(PagingParamsV2 pagingParams) {
    return super.withPagingParams(pagingParams);
  }

  @override
  pagingQuery.PageQueryParams build() {
    return MatchesPageParams(
        baseAsset: baseAsset,
        quoteAsset: quoteAsset,
        orderBookId: orderBookId,
        pagingParams: pagingParams,
        include: include);
  }
}
