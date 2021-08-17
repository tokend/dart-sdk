import 'package:dart_sdk/api/documents/model/document_upload_request.dart';

class OwnerDataEntity<T> {
  T data;

  OwnerDataEntity(this.data);

  OwnerDataEntity.fromJson(Map<String, dynamic> json) : data = json['data'];

  Map<String, dynamic> toJson() => {'data': (data as Owner).toJson()};
}
