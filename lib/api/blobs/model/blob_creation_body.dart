import 'package:dart_sdk/api/base/model/data_entity.dart';
import 'package:dart_sdk/api/blobs/model/blob.dart';
import 'package:dart_sdk/api/documents/model/document_upload_request.dart';

class BlobCreationRequestBody extends Blob {
  Blob blob;
  String? ownerAccountId;

  BlobRelationships? get relationships {
    if (ownerAccountId != null) {
      return BlobRelationships(DataEntity(Owner(ownerAccountId!)));
    }
  }

  BlobCreationRequestBody(this.blob, this.ownerAccountId)
      : super('', blob.typeName, blob.attributes);

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': typeName,
        'attributes': attributes,
        'relationships': relationships?.toJson()
      };
}

class BlobRelationships {
  DataEntity<Owner> owner;

  BlobRelationships(this.owner);

  Map<String, dynamic> toJson() => {'owner': owner.toJson()};
}
