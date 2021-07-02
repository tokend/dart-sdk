enum ClientRedirectType { UNKNOWN, EMAIL_VERIFICATION }

class ClientRedirectTypeExtension {
  static ClientRedirectType fromValue(int value) {
    if (value == 1) {
      return ClientRedirectType.EMAIL_VERIFICATION;
    } else {
      return ClientRedirectType.UNKNOWN;
    }
  }

  static ClientRedirectType fromName(String name) {
    if (name == "api-verify") {
      return ClientRedirectType.EMAIL_VERIFICATION;
    } else {
      return ClientRedirectType.UNKNOWN;
    }
  }
}
