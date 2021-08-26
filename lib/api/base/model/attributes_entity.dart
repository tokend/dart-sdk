/// Represents request body with [T] attributes.
class AttributesEntity<T> {
  T attributes;

  AttributesEntity(this.attributes);

  Map<String, dynamic> toJson() => {'attributes': (attributes)};
}
