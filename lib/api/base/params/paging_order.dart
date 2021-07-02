enum PagingOrder { ASC, DESC }

extension ToLowerCaseString on PagingOrder {
  String toLowerCaseString() {
    return this.toString().toLowerCase();
  }
}
