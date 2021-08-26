class VerifyWalletRequestBody {
  String token;

  VerifyWalletRequestBody(this.token);

  Map<String, dynamic> toJson() => {'token': token};
}
