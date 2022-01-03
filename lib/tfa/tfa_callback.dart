import 'package:dart_sdk/tfa/exceptions.dart';
import 'package:dart_sdk/tfa/tfa_verifier.dart';

/// Used to provide TFA data to complete TFA-protected requests.
abstract class TfaCallback {
  /// Used to be called when TFA error occurred during API request and user's action
  /// is required.
  /// @param exception [NeedTfaException] with all required TFA error data
  /// @param verifierInterface communication object between TFA error handler and TFA verifier
  Future<void> onTfaRequired(NeedTfaException exception,
      TfaVerifierInterface verifierInterface);
}
