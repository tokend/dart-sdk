class WalletData {
  final String type;
  final String? id;
  final String accountId;
  final String email;
  final String encodedKeychainData;
  final String salt;
  final bool isVerified;
  final String? verificationCode;

  WalletData(
      this.type,
      this.id,
      this.accountId,
      this.email,
      this.encodedKeychainData,
      this.salt,
      this.isVerified,
      this.verificationCode);

  WalletData.fromJson(Map<String, dynamic> json)
      : type = json["type"],
        id = json["id"],
        accountId = json["account_id"],
        email = json["email"],
        encodedKeychainData = json["keychain_data"],
        salt = json["salt"],
        isVerified = json["verified"],
        verificationCode = json["verification_doce"];
}
