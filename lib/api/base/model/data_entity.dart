class DataEntity<T> {
  T data;

  DataEntity(this.data);

  DataEntity.fromJson(Map<String, dynamic> json) : data = json['data'];
}
