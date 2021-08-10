class CreateTfaRequestBody {
  final String tfaType;

  CreateTfaRequestBody(this.tfaType);

  CreateTfaRequestBody.fromJson(Map<String, dynamic> json)
      : this.tfaType = json['type'];

  Map<String, dynamic> toJson() => {'type': tfaType};
}
