import 'package:dart_sdk/api/tfa/model/tfa_factor.dart';

/// Result of the TFA factor creation
class TfaFactorCreationResult {
  /// Created f]actor
  final TfaFactor newFactor;

  /// Special attributes required for factor confirmation
  final Map<String, dynamic> confirmationAttributes;

  TfaFactorCreationResult(this.newFactor, this.confirmationAttributes);
}
