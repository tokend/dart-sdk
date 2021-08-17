import 'package:dart_sdk/api/base/base_api.dart';
import 'package:dart_sdk/api/documents/documents_api.dart';
import 'package:dart_sdk/api/wallets/wallets_api.dart';
import 'package:dart_sdk/signing/request_signer.dart';
import 'package:dart_sdk/tfa/tfa_callback.dart';

class TokenDApi extends BaseApi {
  String rootUrl;
  RequestSigner? requestSigner;
  TfaCallback? tfaCallback;
  Map<String, String?>? extraHeaders;
  bool withLogs;

  TokenDApi(this.rootUrl,
      {this.requestSigner,
      this.tfaCallback,
      this.extraHeaders,
      this.withLogs = true})
      : super(rootUrl, requestSigner, tfaCallback, extraHeaders, withLogs);

  DocumentsApi get documents => DocumentsApi(getService());

  WalletsApi get wallets => WalletsApi(getService());
}
