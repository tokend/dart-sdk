import 'package:dart_sdk/api/base/model/link.dart';

/// Response with list of specific [T] items
class Page<T> {
  List<T> get records {
    if (records.isEmpty && embeddedPage != null) {
      return this.embeddedPage!.records;
    } else {
      return records;
    }
  }

  Links? links;
  EmbeddedPage<T>? embeddedPage;
  Links? embeddedLinks;

  Links? getLinks() {
    return this.links ?? this.embeddedLinks;
  }

  Page.fromJson(Map<String, dynamic> json)
      : //records = json['records'], TODO
        links = json['links'],
        embeddedPage = json['_embedded'],
        embeddedLinks = json['_links'];

  Map<String, dynamic> toJson() =>
      {'links': links, '_embedded': embeddedPage, '_links': embeddedLinks};
}

class Links {
  Link? next;
  Link? prev;
  Link? self;

  Links(this.next, this.prev, this.self);

  Links.fromJson(Map<String, dynamic> json)
      : next = json['next'],
        prev = json['prev'],
        self = json['self'];

  Map<String, dynamic> toJson() => {'next': next, 'prev': prev, 'self': self};
}

class EmbeddedPage<T> {
  List<T> records;

  EmbeddedPage(this.records);

  EmbeddedPage.fromJson(Map<String, dynamic> json) : records = json['records'];

  Map<String, dynamic> toJson() => {'records': records};
}
