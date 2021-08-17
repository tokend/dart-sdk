import 'package:dart_sdk/api/base/model/data_entity.dart';
import 'package:dart_sdk/api/custom/custom_requests_api.dart';
import 'package:dio/dio.dart';

import 'model/document_upload_request.dart';

class DocumentsService {
  CustomRequestsApi customRequestsApi;

  DocumentsService(this.customRequestsApi);

  Future<Map<String, dynamic>> requestUpload(dynamic body) {
    print('BODY: ${(body as DataEntity<DocumentUploadRequest>).data.toJson()}');
    return customRequestsApi.post('documents', body: (body.data.toJson()));
  }

  Future<Map<String, dynamic>> upload(String bucketUrl, FormData formData) {
    return customRequestsApi.post(
      bucketUrl,
      body: formData,
    );
  }
}
