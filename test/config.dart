import 'package:dart_wallet/account.dart';

class Config {
  static const API_URL = 'http://localhost:8000/_/api/';
  static const ADMIN_SEED =
      'SAMJKTZVW5UOHCDK5INYJNORF2HRKYI72M5XSZCBYAHQHR34FFR4Z6G4';

  static get ADMIN_ACCOUNT async => await Account.fromSecretSeed(ADMIN_SEED);
}
