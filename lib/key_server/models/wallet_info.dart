import 'package:dart_sdk/key_server/models/login_params.dart';

class WalletInfo {
  String accountId;
  String email;
  String walletIdHex;
  LoginParams loginParams;
  List<String>? _secretSeeds;
  String? legacySingleSecretSeed;

  WalletInfo(this.accountId, this.email, this.walletIdHex, this.loginParams,
      this._secretSeeds);

  WalletInfo.fromJson(Map<String, dynamic> json)
      : accountId = json['accountId'],
        email = json['email'],
        walletIdHex = json['walletIdHex'],
        loginParams = json['loginParams'],
        _secretSeeds = json['secretSeeds'],
        legacySingleSecretSeed = json['secretSeed'] {
    print('JSON $json');
  }

  List<String> get secretSeeds {
    var legacySeed;
    if (legacySingleSecretSeed != null) {
      legacySeed = List.of([legacySingleSecretSeed]);
    }
    var currentSeed = _secretSeeds ?? legacySeed;
    if (currentSeed == null) {
      throw ArgumentError('No secret seeds found');
    }
    return currentSeed;
  }

  set setSecretSeed(String value) {
    _secretSeeds = List.of([value]);
  }

  @override
  int get hashCode {
    var result = accountId.hashCode;
    result = 31 * result + email.hashCode;
    result = 31 * result + walletIdHex.hashCode;
    result = 31 * result + secretSeeds.hashCode;
    result = 31 * result + loginParams.hashCode;
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (!(other is WalletInfo) ||
        accountId != other.accountId ||
        email != other.email ||
        walletIdHex != other.walletIdHex) return false;

    var otherSeeds = other.secretSeeds;

    for (int i = 0; i < secretSeeds.length; i++) {
      if (secretSeeds[i] != otherSeeds[i]) {
        return false;
      }
    }

    if (loginParams != other.loginParams) return false;

    return true;
  }
}
