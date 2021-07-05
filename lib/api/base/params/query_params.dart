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

  void filter(String key, dynamic value) {
    map.addAll({"filter[$key]": value});
  }

  void param(String key, dynamic value) {
    if (value != null) {
      map.addAll({key: value});
    }
  }

  void append(QueryParams extra) {
    map.addAll(extra.map());
  }

  QueryParams build() {
    return _AnonymousQueryParams(map: () => getMap());
  }

  Map<String, dynamic> getMap() {
    return map;
  }
}
