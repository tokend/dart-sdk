import 'package:dart_sdk/api/base/model/data_entity.dart';
import 'package:dart_sdk/api/blobs/model/blob.dart';
import 'package:dart_sdk/api/blobs/model/blob_creation_body.dart';
import 'package:dart_sdk/api/custom/custom_requests_api.dart';

class BLobsApi {
  CustomRequestsApi customRequestsApi;

  BLobsApi(this.customRequestsApi);

  /// Return specific blob by it's id.
  Future<Blob> getBlob(String blobId) {
    return customRequestsApi
        .get('blobs/$blobId')
        .then((response) => Blob.fromJson(response['data']));
  }

  /// Will delete specific blob.
  Future<void> delete(String blobId) {
    return customRequestsApi.delete('blobs/$blobId');
  }

  /// Will create blob.
  Future<Blob> create(Blob blob, {String? ownerAccountId}) {
    return customRequestsApi
        .post('blobs', body: DataEntity(BlobCreationRequestBody(blob, ownerAccountId)).toJson())
        .then((response) => Blob.fromJson(response['data']));
  }
}
