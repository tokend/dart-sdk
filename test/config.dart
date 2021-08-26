import 'package:dart_wallet/account.dart';

class Config {
  static const API_URL = "http://localhost:8000/_/api/";

  //"https://api.staging.helpbees.de/";
  static const API_LOCAL_URL = "http://localhost:8000/_/api/";
  static const ADMIN_SEED =
      "SAMJKTZVW5UOHCDK5INYJNORF2HRKYI72M5XSZCBYAHQHR34FFR4Z6G4";
  static final ADMIN_ACCOUNT = Account.fromSecretSeed(ADMIN_SEED);
}
