class KeychainData {
  final String _encodedIv;
  final String _encodedCipherText;
  String _cipherName = "aes";
  String _cipherMode = "gcm";

  KeychainData(this._encodedIv, this._encodedCipherText, this._cipherName,
      this._cipherMode);
}
