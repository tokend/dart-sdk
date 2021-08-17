class RemoteFile {
  /// Unique identifier of the file
  String key;

  /// Original name of the file with an extension
  String name;

  /// MIME (content) type of the file
  ///
  /// See <a href="https://www.iana.org/assignments/media-types/media-types.xhtml">List of MIME types</a>
  String mimeType;

  RemoteFile(this.key, this.name, this.mimeType);

  String getUrl(String storageRoot) {
    var delimiter = '/';
    if (storageRoot[storageRoot.length - 1] == '/') {
      delimiter = '';
    }
    return storageRoot + delimiter + key;
  }

  bool get isImage => mimeType.contains('image/');

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) {
    return other is RemoteFile && other.key == this.key;
  }
}
