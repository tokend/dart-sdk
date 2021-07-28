import 'package:dart_sdk/tfa/exceptions.dart';

/// Used to provide TFA data to complete TFA-protected requests.
abstract class TfaCallback {
  /// Used to be called when TFA error occurred during API request and user's action
  /// is required.
  /// @param exception [NeedTfaException] with all required TFA error data
  /// @param verifierInterface communication object between TFA error handler and TFA verifier
  void onTfaRequired(NeedTfaException exception
      /*, TfaVerifier.Interface verifierInterface*/); //TODO: need to implement TfaVerifier
}