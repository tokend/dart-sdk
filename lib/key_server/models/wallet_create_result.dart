import 'package:dart_sdk/key_server/models/login_params.dart';
import 'package:dart_sdk/key_server/models/wallet_data.dart';
import 'package:dart_wallet/account.dart';

class WalletCreateResult {
  WalletData walletData;
  Account rootAccount;
  String walletId;
  LoginParams loginParams;
  List<Account> accounts;

  WalletCreateResult(this.walletData, this.rootAccount, this.walletId,
      this.loginParams, this.accounts);
}
