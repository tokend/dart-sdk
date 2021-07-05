abstract class QueryParams {
  Map<String, dynamic> map();
}

class _AnonymousQueryParams implements QueryParams {
  _AnonymousQueryParams({required Map<String, dynamic> map()}) : _map = map;
  final Map<String, dynamic> Function() _map;

  @override
  Map<String, dynamic> map() => _map();
}

class QueryParamsBuilder {
  final Map<String, dynamic> map = {};

  QueryParamsBuilder filter(String key, dynamic value) {
    map.addAll({"filter[$key]": value});
    return this;
  }

  QueryParamsBuilder param(String key, dynamic value) {
    if (value != null) {
      map.addAll({key: value});
    }
    return this;
  }

  QueryParamsBuilder append(QueryParams extra) {
    map.addAll(extra.map());
    return this;
  }

  QueryParams build() {
    return _AnonymousQueryParams(map: () => getMap());
  }

  Map<String, dynamic> getMap() {
    return map;
  }
}
