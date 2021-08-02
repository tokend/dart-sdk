class TfaFactor {
  final int id;
  final String type;
  final String priority;

  TfaFactor(this.id, this.type, this.priority);

  TfaFactor.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        priority = json['priority'];
}
