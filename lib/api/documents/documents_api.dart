import 'dart:convert';

import 'package:dart_sdk/api/base/model/data_entity.dart';
import 'package:dart_sdk/api/base/model/remote_file.dart';
import 'package:dart_sdk/api/custom/custom_requests_api.dart';
import 'package:dart_sdk/api/documents/model/document_type.dart';
import 'package:dart_sdk/api/documents/model/document_upload_request.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

import 'model/document_upload_policy.dart';

class DocumentsApi {
  CustomRequestsApi customRequestsApi;

  static const POLICY_URL_KEY = "url";
  static const REMOTE_FILE_KEY = "key";

  DocumentsApi(this.customRequestsApi);

  /// Will return document upload policy map.
  /// [contentType] must be an allowed MIME type, see allowed types in Docs.
  /// See <a href="https://tokend.gitlab.io/docs/?http#upload">Docs</a>
  Future<Map<String, dynamic>> requestUpload(
      String accountId, DocumentType documentType, String contentType) {
    return requestUploadDoc(
        accountId, describeEnum(documentType).toLowerCase(), contentType);
  }

  /// Will return document upload policy map.
  /// Param [documentType] must be an allowed document type, see allowed types in Docs.
  /// Param [contentType] must be an allowed MIME type, see allowed types in Docs.
  /// See <a href="https://tokend.gitlab.io/docs/?http#upload">Docs</a>
  Future<Map<String, dynamic>> requestUploadDoc(
      String accountId, String documentType, String contentType) {
    return _requestUpload(DataEntity(
        DocumentUploadRequest(documentType, contentType, accountId)));
  }

  /// Uploads given file content according to the policy.
  /// Do not sign this request!
  /// See [requestUpload]
  Future<RemoteFile> upload(DocumentUploadPolicy policy, String contentType,
      String fileName, Uint8List content) {
    var file = MultipartFile.fromBytes(content,
        filename: fileName, contentType: MediaType.parse(contentType));

    var formData =
        new Map<String, dynamic>.from(policy['data']['attributes'] as Map<String, dynamic>);
    formData.remove('id');
    formData.remove('type');
    formData.remove(POLICY_URL_KEY);
    formData.addAll({'file': file});

    var filePart = FormData.fromMap(formData);
    return uploadFileMultipart(policy['data'], filePart).then((_) =>
        RemoteFile(policy['data']['attributes'][REMOTE_FILE_KEY], fileName, contentType));
  }

  Future<void> uploadFileMultipart(DocumentUploadPolicy policy, FormData data) {
    var uploadUrl = policy['attributes'][POLICY_URL_KEY] ?? "";
    return _upload(uploadUrl, data);
  }

  Future<Map<String, dynamic>> _requestUpload(dynamic body) {
    return customRequestsApi.post('documents',
        body: json.encode(body.toJson()));
  }

  Future<void> _upload(String bucketUrl, FormData formData) {
    return customRequestsApi.post(
      bucketUrl,
      body: formData,
    );
  }

  /// Will return full, ready to open document URL
  ///
  /// See <a href="https://docs.tokend.io/identity/#operation/getDocumentURL">Docs</a>
  Future<String> getUrl(String documentKey) {
    return customRequestsApi
        .get('documents/$documentKey')
        .then((response) => response['data']['attributes']['url']);
  }
}
