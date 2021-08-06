import 'package:dart_sdk/api/tokend_api.dart';
import 'package:dart_sdk/signing/account_request_signer.dart';
import 'package:dart_sdk/tfa/tfa_callback.dart';
import 'package:dart_wallet/account.dart';

import 'config.dart';

class Util {
  static TokenDApi getApi({url = Config.API_URL, TfaCallback? tfaCallback}) {
    return TokenDApi(url, tfaCallback: tfaCallback);
  }

  static TokenDApi getSignedApi(Account account,
      {url = Config.API_URL, TfaCallback? tfaCallback}) {
    return TokenDApi(url,
        requestSigner: AccountRequestSigner(account), tfaCallback: tfaCallback);
  }


}
