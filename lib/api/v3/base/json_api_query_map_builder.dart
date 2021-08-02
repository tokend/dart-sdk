import 'package:dart_sdk/api/base/params/query_params.dart';

/// Builds query map for JSONAPI endpoint.
///
/// You can use [JsonApiQueryMapBuilder.append] to append [PageQueryParams] for example
class JsonApiQueryMapBuilder {
  final Map<String, dynamic> _map = {};

  JsonApiQueryMapBuilder filter(String key, dynamic value) {
    _map.addAll({"filter[$key]": value});
    return this;
  }

  JsonApiQueryMapBuilder include(List<String> resource) {
    param("include", resource.join(","));
    return this;
  }

  JsonApiQueryMapBuilder param(String key, dynamic value) {
    if (value != null) {
      _map.addAll({key: value});
    }
    return this;
  }

  JsonApiQueryMapBuilder appendQueryParams(QueryParams extra) {
    return appendMap(extra.map());
  }

  JsonApiQueryMapBuilder appendMap(Map<String, dynamic> extra) {
    _map.addAll(extra);
    return this;
  }

  Map<String, dynamic> build() => _map;
}
