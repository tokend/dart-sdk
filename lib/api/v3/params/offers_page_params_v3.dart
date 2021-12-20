import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/v3/base/json_api_query_params.dart'
    as jsonApiQueryParams;
import 'package:dart_sdk/api/v3/base/page_query_params.dart' as pagingQuery;

class OffersPageParamsV3 extends pagingQuery.PageQueryParams {
  String? baseBalance;
  String? quoteBalance;
  String? baseAsset;
  String? quoteAsset;
  String? ownerAccount;
  int? orderBook;
  bool? isBuy;
  List<String>? include;
  PagingParamsV2? pagingParamsV2;

  OffersPageParamsV3(
      {this.baseBalance,
      this.quoteBalance,
      this.baseAsset,
      this.quoteAsset,
      this.ownerAccount,
      this.orderBook,
      this.isBuy,
      this.pagingParamsV2,
      this.include})
      : super(pagingParamsV2, include);

  @override
  Map<String, dynamic> map() {
    return super.map()
      ..putFilter('base_balance', baseBalance)
      ..putFilter('quote_balance', quoteBalance)
      ..putFilter('base_asset', baseAsset)
      ..putFilter('quote_asset', quoteAsset)
      ..putFilter('owner', ownerAccount)
      ..putFilter('order_book', orderBook)
      ..putFilter('is_buy', isBuy);
  }
}

class OffersPageParamsBuilder extends pagingQuery.Builder {
  String? baseBalance;
  String? quoteBalance;
  String? baseAsset;
  String? quoteAsset;
  String? ownerAccount;
  int? orderBook;
  bool? isBuy;

  @override
  jsonApiQueryParams.Builder withInclude(List<String>? include) {
    return super.withInclude(include);
  }

  @override
  withPagingParams(PagingParamsV2 pagingParams) {
    super.withPagingParams(pagingParams);
  }

  withBaseBalance(String balance) {
    this.baseBalance = balance;
  }

  withQuoteBalance(String balance) {
    this.quoteBalance = balance;
  }

  withBaseAsset(String asset) {
    this.baseAsset = asset;
  }

  withQuoteAsset(String asset) {
    this.quoteAsset = asset;
  }

  withOwnerAccount(String account) {
    this.ownerAccount = account;
  }

  withOrderBook(int orderBook) {
    this.orderBook = orderBook;
  }

  withIsBuy(bool isBuy) {
    this.isBuy = isBuy;
  }

  @override
  pagingQuery.PageQueryParams build() {
    return OffersPageParamsV3(
        baseBalance: baseBalance,
        quoteBalance: quoteBalance,
        baseAsset: baseAsset,
        quoteAsset: quoteAsset,
        ownerAccount: ownerAccount,
        orderBook: orderBook,
        isBuy: isBuy,
        pagingParamsV2: pagingParams,
        include: include);
  }
}

class OffersParams extends jsonApiQueryParams.JsonApiQueryParams {
  List<String>? include;

  OffersParams(this.include) : super(include);

  static const BASE_ASSET = 'base_asset';
  static const QUOTE_ASSET = 'quote_asset';
}
