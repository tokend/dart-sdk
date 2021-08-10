class TfaFactorAttributes {
  final String priority;

  TfaFactorAttributes(this.priority);

  Map<String, dynamic> toJson() => {"priority": priority};
}
