class RemoteFile {
  /// Unique identifier of the file
  String key;

  /// Original name of the file with an extension
  String? name;

  /// MIME (content) type of the file
  ///
  /// See <a href="https://www.iana.org/assignments/media-types/media-types.xhtml">List of MIME types</a>
  String? mimeType;

  RemoteFile(this.key, this.name, this.mimeType);

  RemoteFile.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        name = json['name'],
        mimeType = json['type'];

  Map<String, dynamic> toJson() =>
      {'key': key, 'name': name, 'type': mimeType}; //some models use 'mime_type' as key

  String getUrl(String storageRoot) {
    var delimiter = '/';
    if (storageRoot[storageRoot.length - 1] == '/') {
      delimiter = '';
    }
    return storageRoot + delimiter + key;
  }

  bool get isImage => mimeType?.contains('image/') == true;

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) {
    return other is RemoteFile && other.key == this.key;
  }
}

extension NullFile on RemoteFile? {
  @Deprecated("Better push on JS devs to not send " +
      "invalid file structures as 'no file' instead of using this method")
  bool isReallyNullOrNullAccordingToTheJavascript() {
    return this == null ||
        this?.key.isEmpty == true ||
        this?.name?.isEmpty == true ||
        this?.mimeType?.isEmpty == true;
  }
}
