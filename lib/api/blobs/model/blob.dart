import 'package:dart_sdk/api/blobs/model/blob_type.dart';
import 'package:flutter/foundation.dart';

class Blob {
  String id;
  String typeName;
  BlobsAttributes attributes;

  BlobType? type;

  Blob(this.id, this.typeName, this.attributes) {
    type = Types.fromName(typeName);
  }

  Blob.fromContent(BlobType type, String value, {String id = ''})
      : this(id, describeEnum(type).toLowerCase(), BlobsAttributes(value));

  Blob.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        typeName = json['type'],
        attributes = BlobsAttributes.fromJson(json['attributes']);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Blob && other.id == this.id;
  }
}

class BlobsAttributes {
  String value;

  BlobsAttributes(this.value);

  BlobsAttributes.fromJson(Map<String, dynamic> json) : value = json['value'];

  Map<String, dynamic> toJson() => {'value': value};
}
