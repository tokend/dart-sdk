
import 'package:dart_sdk/signing/request_signer.dart';
import 'package:dart_wallet/utils/hashing.dart';
import 'package:dart_wallet/xdr/utils/dependencies.dart';
import 'package:dio/dio.dart';
import 'package:tuple/tuple.dart';

class SignInterceptor extends Interceptor {
  static const REQUEST_TARGET_HEADER = "(request-target)";
  static const DATE_HEADER = "Date";
  static const AUTH_HEADER = "Authorization";
  static const ACCOUNT_ID_HEADER = "Account-Id";
  static const AUTH_ALGORITHM = "ed25519-sha256";

  String _baseUrl;
  RequestSigner _requestSigner;

  SignInterceptor(this._baseUrl, this._requestSigner);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    buildSignedRequest(options);
    super.onRequest(options, handler);
  }

  /// [relativeUrl] relative endpoint url started with '/'
  /// [method] HTTP method name
  ///
  /// Returns map of headers required for the request to be signed
  static Map<String, String> getSignatureHeaders(
      RequestSigner signer, String method, String relativeUrl) {
    var requestTarget = '${method.toLowerCase()} $relativeUrl';
    var authHeaderContent = _buildHttpAuthHeader(
        signer, List.from([Tuple2(REQUEST_TARGET_HEADER, requestTarget)]));
    return Map.fromEntries(
      [
        MapEntry(AUTH_HEADER, authHeaderContent),
        MapEntry(ACCOUNT_ID_HEADER, signer.originalAccountId)
      ],
    );
  }

  /// Returns string where each row contains header name in lower case and it's content
  static Uint8List _buildHttpSignatureContent(
      List<Tuple2<String, String>> headerContents) {
    var string = '';
    for (int i = 0; i < headerContents.length; i++) {
      var headerPair = headerContents[i];
      string += '${headerPair.item1.toLowerCase()}: ${headerPair.item2}';
      if (i != headerContents.length - 1) {
        string += '\n';
      }
    }
    return Uint8List.fromList(string.codeUnits);
  }

  /// Returns auth header content according to the signing requirements
  /// See <a href="https://tokend.gitbook.io/knowledge-base/technical-details/security#rest-api">Requests signing on Knowledge base</a>
  static String _buildHttpAuthHeader(RequestSigner requestSigner,
      List<Tuple2<String, String>> headerContents) {
    var contentToSign = _buildHttpSignatureContent(headerContents);
    var hashToSign = Hashing.sha256hashing(contentToSign);

    var signatureBase64 = requestSigner.signToBase64(hashToSign);
    var keyId = requestSigner.accountId;
    var headersString = headerContents.map((e) => e.item1).join(' ');

    return 'keyId=\"$keyId\",algorithm=\"$AUTH_ALGORITHM\"' +
        ',signature=\"$signatureBase64\",headers=\"$headersString\"';
  }

  buildSignedRequest(RequestOptions options) {
    var method = options.method;
    var url = options.uri;
    var relativeUrl = url.toString().substring(_baseUrl.length);

    if (!(relativeUrl[0] == "/")) {
      relativeUrl = "/$relativeUrl";
    }

    var headers = getSignatureHeaders(_requestSigner, method, relativeUrl);

    options.headers.addAll(headers);
  }
}
