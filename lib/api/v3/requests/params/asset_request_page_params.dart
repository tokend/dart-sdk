import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/v3/base/json_api_query_params.dart';
import 'package:dart_sdk/api/v3/base/page_query_params.dart';
import 'package:dart_sdk/api/v3/requests/model/request_model.dart';
import 'package:dart_sdk/api/v3/requests/params/request_page_params_v3.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';

class AssetRequestPageParams extends RequestPageParamsV3 {
  String? assetCode;

  AssetRequestPageParams(
    String? reviewer,
    String? requestor,
    RequestState? state,
    ReviewableRequestType? type,
    int? pendingTasks,
    int? pendingTasksNotSet,
    int? pendingTasksAnyOf,
    int? missingPendingTasks,
    PagingParamsV2? pagingParams,
    List<String>? include, {
    this.assetCode,
  }) : super(reviewer, requestor, state, type, pendingTasks, pendingTasksNotSet,
            pendingTasksAnyOf, missingPendingTasks, pagingParams, include);

  @override
  Map<String, dynamic> map() {
    return super.map()..putFilter('request_details.asset', this.assetCode);
  }
}

class AssetRequestPageParamsBuilder extends RequestPageParamsV3Builder {
  String? assetCode;

  withAssetCode(String assetCode) {
    this.assetCode = assetCode;
  }

  @override
  PageQueryParams build() {
    return AssetRequestPageParams(
        reviewer,
        requestor,
        state,
        type,
        pendingTasks,
        pendingTasksNotSet,
        pendingTasksAnyOf,
        missingPendingTasks,
        pagingParams,
        include);
  }
}
