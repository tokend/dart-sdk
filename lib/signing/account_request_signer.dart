import 'dart:typed_data';

import 'package:dart_sdk/signing/request_signer.dart';
import 'package:dart_sdk/utils/extensions/encoding.dart';
import 'package:dart_wallet/account.dart';

/// Request signer based on given [Account].
///
/// @param [account] must be active signer.
///
/// @see <a href="https://tokend.gitbook.io/knowledge-base/technical-details/key-entities/accounts#signers">Knowledge base</a>
/// @see <a href="https://tokend.gitbook.io/knowledge-base/technical-details/security#rest-api">Requests signing on Knowledge base</a>
class AccountRequestSigner implements RequestSigner {
  Account _account;
  @override
  String originalAccountId = "";

  @override
  String accountId;

  AccountRequestSigner(this._account, {this.accountId = ""}) {
    accountId = _account.accountId;
  }

  @override
  Future<String> signToBase64(Uint8List data) {
    return _account.sign(data).then((value) => value.encodeBase64String());
  }
}
