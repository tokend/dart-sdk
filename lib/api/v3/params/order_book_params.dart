import 'package:dart_sdk/api/v3/base/json_api_query_params.dart'
    as jsonApiQueryParams;

class OrderBookParamsV3 extends jsonApiQueryParams.JsonApiQueryParams {
  int? maxEntries;
  List<String>? include;

  OrderBookParamsV3({this.maxEntries, this.include}) : super(include);

  @override
  Map<String, dynamic> map() {
    return map()..putFilter('max_entries', maxEntries);
  }
}

class OrderBookParamsBuilder extends jsonApiQueryParams.Builder {
  int? maxEntries;
  List<String>? include;

  @override
  jsonApiQueryParams.Builder withInclude(List<String>? include) {
    return super.withInclude(include);
  }

  @override
  jsonApiQueryParams.JsonApiQueryParams build() {
    return OrderBookParamsV3(maxEntries: maxEntries, include: include);
  }
}

class OrderBookParams extends jsonApiQueryParams.JsonApiQueryParams {
  List<String>? include;

  OrderBookParams(this.include) : super(include);

  static const BASE_ASSET = 'base_asset';
  static const QUOTE_ASSET = 'quote_asset';
  static const BUY_ENTRIES = 'buy_entries';
  static const SELL_ENTRIES = "sell_entries";
}
