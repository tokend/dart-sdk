import 'package:dart_sdk/api/base/params/query_params.dart';

class JsonApiQueryParams implements QueryParams {
  final List<String>? include;

  JsonApiQueryParams(this.include);

  @override
  Map<String, dynamic> map() {
    final Map<String, dynamic> map = {};
    map.addAll({"include": include?.join(",")});
    return map;
  }
}

class Builder {
  List<String>? include;

  Builder withInclude(List<String>? include) {
    this.include = include;
    return this;
  }

  JsonApiQueryParams build() {
    return JsonApiQueryParams(include);
  }
}

/// Will put given [value] with key "`filter[key]`", i.e. "`filter[price]`" if it is not null
extension JsonApiQueryParamsExtension on Map<String, dynamic> {
  Map<String, dynamic> putFilter(String key, dynamic value) {
    if (value != null) {
      this.putQueryParam("filter", key, value);
      return this;
    }
    return this; //TODO: need to check
  }

  /// Will put given [value] with key "`type[key]`", i.e. "`filter[price]`"
  Map<String, dynamic> putQueryParam(String type, String key, dynamic value) {
    this.addAll({"$type[$key]": value});
    return this;
  }
}
