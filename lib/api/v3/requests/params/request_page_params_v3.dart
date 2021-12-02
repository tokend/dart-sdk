import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/v3/base/json_api_query_params.dart' as pageQuery;
import 'package:dart_sdk/api/v3/base/page_query_params.dart' as pageParams;
import 'package:dart_sdk/api/v3/requests/model/request_model.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';

class RequestPageParamsV3 extends pageParams.PageQueryParams {
  RequestPageParamsV3(
      this.reviewer,
      this.requestor,
      this.state,
      this.type,
      this.pendingTasks,
      this.pendingTasksNotSet,
      this.pendingTasksAnyOf,
      this.missingPendingTasks,
      PagingParamsV2? pagingParams,
      List<String>? include)
      : super(pagingParams, include);

  String? reviewer;
  String? requestor;
  RequestState? state;
  ReviewableRequestType? type;
  int? pendingTasks;
  int? pendingTasksNotSet;
  int? pendingTasksAnyOf;
  int? missingPendingTasks;

  @override
  Map<String, dynamic> map() {
    return super.map()
      ..putFilter('reviewer', reviewer)
      ..putFilter('requestor', requestor)
      ..putFilter('state', state)
      ..putFilter('type', type?.value)
      ..putFilter('pending_tasks', pendingTasks)
      ..putFilter('pending_tasks_not_set', pendingTasksNotSet)
      ..putFilter('pending_tasks_any_of', pendingTasksAnyOf)
      ..putFilter('missing_pending_tasks', missingPendingTasks);
  }
}

class RequestPageParamsV3Builder extends pageParams.Builder {
  String? reviewer;
  String? requestor;
  RequestState? state;
  ReviewableRequestType? type;
  int? pendingTasks;
  int? pendingTasksNotSet;
  int? pendingTasksAnyOf;
  int? missingPendingTasks;

  withReviewer(String reviewer) {
    this.reviewer = reviewer;
  }

  withRequestor(String requestor) {
    this.requestor = requestor;
  }

  withState(RequestState state) {
    this.state = state;
  }

  withType(ReviewableRequestType type) {
    this.type = type;
  }

  withPendingTasks(int pendingTasks) {
    this.pendingTasks = pendingTasks;
  }

  withPendingTasksNotSet(int pendingTasksNotSet) {
    this.pendingTasksNotSet = pendingTasksNotSet;
  }

  withPendingTasksAnyOf(int pendingTasksAnyOf) {
    this.pendingTasksAnyOf = pendingTasksAnyOf;
  }

  withMissingPendingTasks(int missingPendingTasks) {
    this.pendingTasksAnyOf = pendingTasksAnyOf;
  }

  @override
  withPagingParams(PagingParamsV2 pagingParams) {
    return super.withPagingParams(pagingParams);
  }

  @override
  pageQuery.Builder withInclude(List<String>? include) {
    return super.withInclude(include);
  }

  @override
  pageParams.PageQueryParams build() {
    return RequestPageParamsV3(
      reviewer,
      requestor,
      state,
      type,
      pendingTasks,
      pendingTasksNotSet,
      pendingTasksAnyOf,
      missingPendingTasks,
      pagingParams,
      include,
    );
  }
}
