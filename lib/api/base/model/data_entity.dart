/// Represents request body with [T] data.
class DataEntity<T> {
  late T data;

  DataEntity(this.data);

  DataEntity.fromJson(dynamic json) {
    if (json is Map<dynamic, dynamic>) {
      data = json['data'];
    } else if (json is List<Map<dynamic, dynamic>>) {
      var dataList = [];
      json.forEach((item) {
        dataList.add(DataEntity.fromJson(item));
      });
      data = dataList as T;
    }
  }

  Map<String, dynamic> toJson() {
    var json;
    if (data is Iterable) {
      json = <Map<dynamic, dynamic>>[];
      (data as Iterable).forEach((element) {
        json.add(element.toJson());
      });
    } else {
      var list = List.of([data]);
      // Cast is necessary because of compiler error
      (list as Iterable).forEach((element) {
        json = element?.toJson();
      });
    }
    return {'data': json};
  }
}
