class SubmitTransactionResponse {
  final Extras? extras;
  final int? ledger;
  final String? createdAt;
  final String? hash;
  final String _envelopeXdr;
  final String _resultXdr;
  final String? resultMetaXdr;

  SubmitTransactionResponse(this.extras, this.ledger, this.createdAt, this.hash,
      this._envelopeXdr, this._resultXdr, this.resultMetaXdr);

  SubmitTransactionResponse.fromJson(Map<String, dynamic> json)
      : extras = Extras.fromJson(json['extras']),
        ledger = json['ledger'],
        createdAt = json['created_at'],
        hash = json['hash'],
        _envelopeXdr = json['envelope_xdr'],
        _resultXdr = json['result_xdr'],
        resultMetaXdr = json['result_meta_xdr'];

  bool get isSuccess => ledger != null;

  String getEnvelopeXdr() {
    if (this.isSuccess) {
      return this._envelopeXdr;
    } else {
      return this.extras!.envelopeXdr;
    }
  }
}

class Extras {
  final String envelopeXdr;
  final String resultXdr;
  final ResultCodes resultCodes;
  final Map<String, dynamic> parsedResultJson;

  Extras(this.envelopeXdr, this.resultXdr, this.resultCodes,
      this.parsedResultJson);

  Extras.fromJson(Map<String, dynamic> json)
      : envelopeXdr = json['envelope_xdr'],
        resultXdr = json['result_xdr'],
        resultCodes = ResultCodes.fromJson(json['result_codes']),
        parsedResultJson = json['parsed_result'];
}

class ResultCodes {
  final String transactionResultCode;
  final List<String> operationsResultCodes;

  ResultCodes(this.transactionResultCode, this.operationsResultCodes);

  ResultCodes.fromJson(Map<String, dynamic> json)
      : transactionResultCode = json['transaction'],
        operationsResultCodes = json['operations'];
}