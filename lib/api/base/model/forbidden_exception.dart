import 'dart:io';

class ForbiddenException implements IOException {
  final String _type;
  final String _detailMessage;

  const ForbiddenException([this._type = "", this._detailMessage = ""]);

  String toString() => "ForbiddenException: $_detailMessage";
}
