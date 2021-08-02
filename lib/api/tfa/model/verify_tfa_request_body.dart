class VerifyTfaRequestBody {
  final String token;
  final String otp;

  VerifyTfaRequestBody(this.token, this.otp);

  VerifyTfaRequestBody.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        otp = json['otp'];

  Map<String, dynamic> toJson() => {'token': token, 'otp': otp};
}
