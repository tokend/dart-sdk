import 'package:dart_sdk/api/base/params/paging_order.dart';

/// Common paging params.
class PagingParamsHolder {
  PagingOrder? order;
  String? cursor;
  int? limit;
}
