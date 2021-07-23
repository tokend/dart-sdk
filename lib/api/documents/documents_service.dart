import 'dart:convert';

import 'package:dio/dio.dart';

class DocumentsService {
  Future<Response> requestUpload(Dio dio, dynamic body) {
    return dio.post('documents', data: jsonEncode(body));
  }

  Future<Response> upload(Dio dio, String bucketUrl, FormData formData) {
    return dio.post(
      bucketUrl,
      data: formData,
    );
  }
}
