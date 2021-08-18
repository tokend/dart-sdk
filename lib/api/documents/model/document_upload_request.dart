import 'owner_data_entity.dart';

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

  Map<String, dynamic> toJson() => {
        'type': type,
        'attributes': attributes.toJson(),
        'relationships': relationships.toJson(),
      };
}

class DocumentUploadRequestAttributes {
  String contentType;

  DocumentUploadRequestAttributes(this.contentType);

  Map<String, dynamic> toJson() => {
        'content_type': contentType,
      };
}

class DocumentUploadRequestRelationships {
  late String ownerAccountId;

  late OwnerDataEntity owner;

  DocumentUploadRequestRelationships(String ownerAccountId) {
    this.ownerAccountId = ownerAccountId;
    this.owner = OwnerDataEntity(Owner(ownerAccountId));
  }

  Map<String, dynamic> toJson() => {'owner': owner.toJson()};
}

class Owner {
  String id;

  Owner(this.id);

  Map<String, dynamic> toJson() => {'id': id};
}