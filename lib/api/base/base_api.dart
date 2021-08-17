import 'package:dart_sdk/api/custom/custom_requests_api.dart';
import 'package:dart_sdk/factory/service_factory.dart';
import 'package:dart_sdk/signing/request_signer.dart';
import 'package:dart_sdk/tfa/tfa_callback.dart';

abstract class BaseApi {
  String rootUrl;
  RequestSigner? requestSigner;
  TfaCallback? tfaCallback;
  Map<String, String?>? extraHeaders;
  bool withLogs;

  BaseApi(this.rootUrl, this.requestSigner, this.tfaCallback, this.extraHeaders,
      this.withLogs);

  ServiceFactory get serviceFactory =>
      ServiceFactory(rootUrl, withLogs, extraHeaders);

  CustomRequestsApi getService() {
    return serviceFactory.getService(
        requestSigner: requestSigner, tfaCallback: tfaCallback);
  }

  bool get isSigned {
    return requestSigner != null;
  }

  String? get signerAccountId {
    return requestSigner?.accountId;
  }
}
