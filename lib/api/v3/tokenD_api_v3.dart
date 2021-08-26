import 'package:dart_sdk/api/base/base_api.dart';
import 'package:dart_sdk/api/v3/keyvalue/key_value_storage_api_v3.dart';
import 'package:dart_sdk/api/v3/signers/signers_api_v3.dart';
import 'package:dart_sdk/signing/request_signer.dart';
import 'package:dart_sdk/tfa/tfa_callback.dart';

class TokenDApiV3 extends BaseApi {
  String rootUrl;
  RequestSigner? requestSigner;
  TfaCallback? tfaCallback;
  Map<String, String?>? extraHeaders;
  bool withLogs;

  TokenDApiV3(this.rootUrl,
      {this.requestSigner,
      this.tfaCallback,
      this.extraHeaders,
      this.withLogs = true})
      : super(rootUrl, requestSigner, tfaCallback, extraHeaders, withLogs);

  KeyValueStorageApiV3 get keyValue => KeyValueStorageApiV3(getService());
  SignersApiV3 get signers => SignersApiV3(getService());

}
