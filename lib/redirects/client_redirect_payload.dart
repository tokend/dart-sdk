import 'dart:convert';

import 'package:dart_sdk/redirects/client_redirect_type.dart';
import 'package:dart_sdk/utils/extensions/encoding.dart';

/// Holds client redirect data.
/// @see <a href="https://tokend.gitlab.io/docs/?http#client-redirects">Docs</a>
class ClientRedirectPayload {
  final String typeName;
  final String meta; //JsonObject
  static const String _REDIRECT_PATH_SEGMENT = 'r';

  ClientRedirectPayload(this.typeName, this.meta);

  ClientRedirectPayload.fromJson(Map<String, dynamic> json)
      : typeName = json['type'],
        meta = json['meta'];

  ClientRedirectType get type {
    return ClientRedirectTypeExtension.fromName(typeName);
  }

  static ClientRedirectPayload? fromUrl(String url) {
    final parsedUrl = Uri.parse(url);
    final pathSegments = parsedUrl.pathSegments;
    final payloadIndex = pathSegments.indexOf(_REDIRECT_PATH_SEGMENT) + 1;
    final encodedPayload = pathSegments[payloadIndex];

    try {
      final decodedPayload = encodedPayload.decodeBase64();
      if (decodedPayload != null) {
        var payloadJson = jsonDecode(decodedPayload.toString());
        return ClientRedirectPayload.fromJson(payloadJson);
      }
    } catch (exception) {
      return null;
    }
  }
}
