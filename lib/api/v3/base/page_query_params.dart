import 'package:dart_sdk/api/base/params/paging_order.dart';
import 'package:dart_sdk/api/base/params/paging_params_holder.dart';
import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/v3/base/json_api_query_params.dart'
    as JsonApiQueryParams;

class PageQueryParams extends JsonApiQueryParams.JsonApiQueryParams
    implements PagingParamsHolder {
  final PagingParamsV2? pagingParams;

  final List<String>? include;

  PageQueryParams(this.pagingParams, this.include) : super(include) {
    cursor = pagingParams?.cursor;
    limit = pagingParams?.limit;
    order = pagingParams?.order;
  }

  @override
  String? cursor;

  @override
  int? limit;

  @override
  PagingOrder? order;

  @override
  Map<String, dynamic> map() {
    final Map<String, dynamic> map = super.map();
    if (pagingParams != null) {
      map.addAll(pagingParams!.map());
    }
    return map;
  }
}

class Builder extends JsonApiQueryParams.Builder {
  PagingParamsV2? pagingParams;

  @override
  JsonApiQueryParams.Builder withInclude(List<String>? include) {
    return super.withInclude(include);
  }

  PageQueryParams build() {
    return PageQueryParams(pagingParams, include);
  }
}
