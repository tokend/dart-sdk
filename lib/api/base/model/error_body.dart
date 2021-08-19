import 'dart:convert';

import 'package:dart_sdk/api/base/model/server_error.dart';

/// Holds errors returned from server.
class ErrorBody {
  List<ServerError> errors = [];

  ErrorBody(this.errors);

  ErrorBody.fromJson(Map<String, dynamic> json) {
    json['errors'].forEach((v) {
      errors.add(ServerError.fromJson(v));
    });
  }

  /// Returns first error or [null] if there are no errors somehow.
  ServerError? get firstOrNull => errors.first;

  static ErrorBody fromJsonString(String json) {
    return ErrorBody.fromJson(jsonDecode(json));
  }
}
