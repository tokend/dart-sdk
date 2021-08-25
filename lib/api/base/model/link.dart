/// Represents links in responses.
class Link {
  String href;
  bool isTemplated;

  Link.fromJson(Map<String, dynamic> json)
      : href = json['href'],
        isTemplated = json['templated'];

  Map<String, dynamic> toJson() => {'href': href, 'templated': isTemplated};

  Uri get uri {
    try {
      return Uri.parse(href);
    } catch (e) {
      throw e;
    }
  }
}
