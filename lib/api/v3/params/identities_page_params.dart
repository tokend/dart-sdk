import 'package:dart_sdk/api/base/params/paging_params_v2.dart';
import 'package:dart_sdk/api/v3/base/json_api_query_params.dart'
    as jsonApiQueryParams;
import 'package:dart_sdk/api/v3/base/page_query_params.dart' as pagingQuery;

class IdentitiesPageParams extends pagingQuery.PageQueryParams {
  String? email;
  String? address;
  String? phone;
  String? passport;
  String? identifier;
  List<String>? include;
  PagingParamsV2? pagingParams;

  IdentitiesPageParams(this.email, this.address, this.phone, this.passport,
      this.identifier, this.include, this.pagingParams)
      : super(pagingParams, include);

  @override
  Map<String, dynamic> map() {
    return super.map()
      ..putFilter('email', email)
      ..putFilter('address', address)
      ..putFilter('phone', phone)
      ..putFilter('passport', passport)
      ..putFilter('identifier', identifier);
  }
}

class IdentitiesPageParamsBuilder extends pagingQuery.Builder {
  String? email;
  String? address;
  String? phone;
  String? passport;
  String? identifier;
  List<String>? include;
  PagingParamsV2? pagingParams;

  withEmail(String email) => this.email = email;

  withAddress(String address) => this.address = address;

  withPhone(String phone) => this.phone = phone;

  withPassport(String passport) => this.passport = passport;

  withIdentifier(String identifier) => this.identifier = identifier;

  @override
  jsonApiQueryParams.Builder withInclude(List<String>? include) {
    return super.withInclude(include);
  }

  @override
  withPagingParams(PagingParamsV2 pagingParams) {
    super.withPagingParams(pagingParams);
  }

  @override
  pagingQuery.PageQueryParams build() => IdentitiesPageParams(
      email, address, phone, passport, identifier, include, pagingParams);
}
