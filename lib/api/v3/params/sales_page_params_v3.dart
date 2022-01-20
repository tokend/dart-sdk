import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/v3/base/json_api_query_params.dart'
    as jsonApiQueryParams;
import 'package:dart_sdk/api/v3/base/page_query_params.dart' as pagingQuery;
import 'package:dart_wallet/xdr/xdr_types.dart';
import 'package:decimal/decimal.dart';

class SalesPageParamsV3 extends pagingQuery.PageQueryParams {
  String? owner;
  DateTime? minStartTime;
  DateTime? minEndTime;
  DateTime? maxStartTime;
  DateTime? maxEndTime;

  /*
  * 1- opened
  * 2- closed
  * 3- canceled
  * */
  int? saleState;
  Decimal? maxSoftCap;
  Decimal? maxHardCap;
  Decimal? minSoftCap;
  Decimal? minHardCap;
  String? baseAsset;
  SaleType? saleType;
  List<String>? include;
  PagingParamsV2? pagingParamsV2;

  SalesPageParamsV3({
    this.owner,
    this.minStartTime,
    this.minEndTime,
    this.maxStartTime,
    this.maxEndTime,
    this.saleState,
    this.maxSoftCap,
    this.maxHardCap,
    this.minSoftCap,
    this.minHardCap,
    this.baseAsset,
    this.saleType,
    this.include,
    this.pagingParamsV2,
  }) : super(pagingParamsV2, include);

  @override
  Map<String, dynamic> map() {
    return super.map()
      ..putFilter('owner', owner)
      ..putFilter('min_start_time', minStartTime)
      ..putFilter('min_end_time', minEndTime)
      ..putFilter('max_start_time', maxStartTime)
      ..putFilter('max_end_time', maxEndTime)
      ..putFilter('state', saleState)
      ..putFilter('max_soft_cap', maxSoftCap)
      ..putFilter('max_hard_cap', maxHardCap)
      ..putFilter('min_soft_cap', minSoftCap)
      ..putFilter('min_hard_cap', minHardCap)
      ..putFilter('max_soft_cap', maxSoftCap)
      ..putFilter('base_asset', baseAsset)
      ..putFilter('sale_type', saleType?.value);
  }
}

class OffersPageParamsBuilder extends pagingQuery.Builder {
  String? owner;
  DateTime? minStartTime;
  DateTime? minEndTime;
  DateTime? maxStartTime;
  DateTime? maxEndTime;
  int? saleState;
  Decimal? maxSoftCap;
  Decimal? maxHardCap;
  Decimal? minSoftCap;
  Decimal? minHardCap;
  String? baseAsset;
  SaleType? saleType;

  @override
  jsonApiQueryParams.Builder withInclude(List<String>? include) {
    return super.withInclude(include);
  }

  @override
  withPagingParams(PagingParamsV2 pagingParams) {
    super.withPagingParams(pagingParams);
  }

  withOwner(String owner) {
    this.owner = owner;
  }

  withMinStartTime(DateTime minStartTime) {
    this.minStartTime = minStartTime;
  }

  withMinEndTime(DateTime minEndTime) {
    this.minEndTime = minEndTime;
  }

  withMaxStartTime(DateTime maxStartTime) {
    this.maxStartTime = maxStartTime;
  }

  withMaxEndTime(DateTime maxEndTime) {
    this.maxEndTime = maxEndTime;
  }

  withState(int saleState) {
    this.saleState = saleState;
  }

  withMaxSoftCap(Decimal maxSoftCap) {
    this.maxSoftCap = maxSoftCap;
  }

  withMaxHardCap(Decimal maxHardCap) {
    this.maxHardCap = maxHardCap;
  }

  withMinSoftCap(Decimal minSoftCap) {
    this.minSoftCap = minSoftCap;
  }

  withMinHardCap(Decimal mainHardCap) {
    this.minHardCap = mainHardCap;
  }

  withBaseAsset(String baseAsset) {
    this.baseAsset = baseAsset;
  }

  withSaleType(SaleType saleType) {
    this.saleType = saleType;
  }

  @override
  pagingQuery.PageQueryParams build() {
    return SalesPageParamsV3(
        owner: owner,
        minStartTime: minStartTime,
        minEndTime: minEndTime,
        maxStartTime: maxStartTime,
        maxEndTime: maxEndTime,
        saleState: saleState,
        maxSoftCap: maxSoftCap,
        maxHardCap: maxHardCap,
        minSoftCap: minSoftCap,
        minHardCap: minHardCap,
        baseAsset: baseAsset,
        saleType: saleType,
        include: include,
        pagingParamsV2: pagingParams);
  }
}

class SalesParams extends jsonApiQueryParams.JsonApiQueryParams {
  List<String>? include;

  SalesParams(this.include) : super(include);

  static const BASE_ASSET = 'base_asset';
  static const QUOTE_ASSET = 'quote_asset';
  static const DEFAULT_QUOTE_ASSET = 'default_quote_asset';
}
