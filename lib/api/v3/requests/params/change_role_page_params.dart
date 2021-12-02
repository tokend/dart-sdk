import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/v3/base/json_api_query_params.dart' as pageQuery;
import 'package:dart_sdk/api/v3/base/page_query_params.dart';
import 'package:dart_sdk/api/v3/requests/model/request_model.dart';
import 'package:dart_sdk/api/v3/requests/params/request_page_params_v3.dart';
import 'package:dart_wallet/xdr/xdr_types.dart';

/// See [ChangeRoleRequestIncludes]
class ChangeRoleRequestPageParams extends RequestPageParamsV3 {
  String? destinationAccount;
  int? accountRoleToSet;

  ChangeRoleRequestPageParams(
    String? reviewer,
    String? requestor,
    RequestState? state,
    int? pendingTasks,
    int? pendingTasksNotSet,
    int? pendingTasksAnyOf,
    int? missingPendingTasks,
    PagingParamsV2? pagingParams,
    List<String>? include, {
    this.destinationAccount,
    this.accountRoleToSet,
  }) : super(
            reviewer,
            requestor,
            state,
            ReviewableRequestType(ReviewableRequestType.CHANGE_ROLE),
            pendingTasks,
            pendingTasksNotSet,
            pendingTasksAnyOf,
            missingPendingTasks,
            pagingParams,
            include);

  @override
  Map<String, dynamic> map() {
    return super.map()
      ..putFilter('request_details.destination_account', destinationAccount)
      ..putFilter('request_details.account_role_to_set', accountRoleToSet);
  }
}

class cPageParamsBuilder extends RequestPageParamsV3Builder {
  String? destinationAccount;
  int? accountRoleToSet;

  withDestinationAccount(String destinationAccount) {
    this.destinationAccount = destinationAccount;
  }

  withAccountRoleToSet(int accountRolToSet) {
    this.accountRoleToSet = accountRoleToSet;
  }

  withReviewer(String reviewer) {
    super.withReviewer(reviewer);
  }

  withRequestor(String requestor) {
    super.withRequestor(requestor);
  }

  withState(RequestState state) {
    super.withState(state);
  }

  withType(ReviewableRequestType type) {
    super.withType(type);
  }

  withPendingTasks(int pendingTasks) {
    super.withPendingTasks(pendingTasks);
  }

  withMissingPendingTasks(int missingPendingTasks) {
    super.withMissingPendingTasks(missingPendingTasks);
  }

  @override
  pageQuery.Builder withInclude(List<String>? include) {
    return super.withInclude(include);
  }

  @override
  PageQueryParams build() {
    return ChangeRoleRequestPageParams(
        reviewer,
        requestor,
        state,
        pendingTasks,
        pendingTasksNotSet,
        pendingTasksAnyOf,
        missingPendingTasks,
        pagingParams,
        include);
  }
}

class ChangeRoleRequestIncludes {
  static const DESTINATION_ACCOUNT = "request_details.account";
}
