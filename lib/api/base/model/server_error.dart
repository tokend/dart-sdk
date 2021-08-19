/// Represents Server error.
class ServerError {
  final String? title;
  final int? status;
  final String? detail;
  final Map<String, dynamic>? meta;

  ServerError(this.title, this.status, this.detail, this.meta);

  ServerError.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        status = int.parse(json["status"]),
        detail = json["detail"],
        meta = json["meta"] != null ? json["meta"] : null;
}
