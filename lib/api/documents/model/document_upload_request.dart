import 'package:dart_sdk/api/base/model/data_entity.dart';

class DocumentUploadRequest {
  String type;
  String contentType;
  String ownerAccountId;
  late DocumentUploadRequestAttributes attributes;
  late DocumentUploadRequestRelationships relationships;

  DocumentUploadRequest(this.type, this.contentType, this.ownerAccountId) {
    attributes = DocumentUploadRequestAttributes(contentType);
    relationships = DocumentUploadRequestRelationships(ownerAccountId);
  }
}

class DocumentUploadRequestAttributes {
  String contentType;

  DocumentUploadRequestAttributes(this.contentType);
}

class DocumentUploadRequestRelationships {
  late String ownerAccountId;

  late DataEntity owner;

  DocumentUploadRequestRelationships(String ownerAccountId) {
    this.ownerAccountId = ownerAccountId;
    this.owner = DataEntity(Owner(ownerAccountId));
  }
}

class Owner {
  String id;

  Owner(this.id);
}
