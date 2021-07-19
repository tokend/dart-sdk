import 'dart:convert';

import 'package:dart_sdk/api/base/model/server_error.dart';

/// Holds errors returned from server.
class ErrorBody {
  final List<ServerError> errors;

  ErrorBody(this.errors);

  ErrorBody.fromJson(Map<String, dynamic> json) : errors = json["errors"];

  /// Returns first error or [null] if there are no errors somehow.
  ServerError? get firstOrNull => errors.first;

  static ErrorBody fromJsonString(String json) {
    return ErrorBody.fromJson(jsonDecode(json));
  }
}
