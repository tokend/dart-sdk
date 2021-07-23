import 'package:dart_sdk/api/base/model/data_entity.dart';
import 'package:dart_sdk/api/custom/custom_requests_service.dart';
import 'package:dart_sdk/api/documents/documents_service.dart';
import 'package:dart_sdk/api/documents/model/document_type.dart';
import 'package:dart_sdk/api/documents/model/document_upload_request.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'model/document_upload_policy.dart';

class DocumentsApi {
  DocumentsService documentsService;
  CustomRequestService customRequestService;
  Dio _dio;

  static const POLICY_URL_KEY = "url";
  static const REMOTE_FILE_KEY = "key";

  DocumentsApi(this.documentsService, this.customRequestService, this._dio);

  Future<Response> requestUpload(
      String accountId, DocumentType documentType, String contentType) {
    return requestUploadDoc(accountId, describeEnum(documentType), contentType);
  }

  /// Will return document upload policy map.
  /// Param [documentType] must be an allowed document type, see allowed types in Docs.
  /// Param [contentType] must be an allowed MIME type, see allowed types in Docs.
  /// See <a href="https://tokend.gitlab.io/docs/?http#upload">Docs</a>
  Future<Response> requestUploadDoc(
      String accountId, String documentType, String contentType) {
    return documentsService.requestUpload(
        _dio,
        DataEntity(
            DocumentUploadRequest(documentType, contentType, accountId)));
  }

  /// Uploads given file content according to the policy.
  /// Do not sign this request!
  /// See [requestUpload]
  upload(DocumentUploadPolicy policy, String contentType, String fileName,
      Uint8List content) {
    var file = MultipartFile.fromBytes(content);
    var filePart = FormData.fromMap({'file': fileName, 'content': file});
    uploadFileMultipart(policy, filePart);
  }

  uploadFileMultipart(DocumentUploadPolicy policy, FormData data) {
    var uploadUrl = policy[POLICY_URL_KEY] ?? "";
    documentsService.upload(_dio, uploadUrl, data);
  }
}
