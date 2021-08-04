import 'package:dart_sdk/key_server/models/login_params.dart';

class WalletInfo {
  String accountId;
  String email;
  String walletIdHex;
  LoginParams loginParams;
  List<String>? _secretSeeds;
  String? legacySingleSecretSeed;

  WalletInfo.fromJson(Map<String, dynamic> json)
      : accountId = json['accountId'],
        email = json['email'],
        walletIdHex = json['walletIdHex'],
        loginParams = json['loginParams'],
        _secretSeeds = json['secretSeeds'];

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

  //TODO equals and hashcode methods
}
