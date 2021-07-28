import 'package:dart_sdk/api/base/base_api.dart';
import 'package:dart_sdk/signing/request_signer.dart';
import 'package:dart_sdk/tfa/tfa_callback.dart';

class TokenDApi extends BaseApi {
  String rootUrl;
  RequestSigner? requestSigner;
  TfaCallback? tfaCallback;
  Map<String, String?>? extraHeaders;
  bool withLogs;

  TokenDApi(this.rootUrl, this.requestSigner, this.tfaCallback,
      this.extraHeaders, this.withLogs)
      : super(rootUrl, requestSigner, tfaCallback, extraHeaders, withLogs);
}
