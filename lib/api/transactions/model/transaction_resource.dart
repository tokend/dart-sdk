class TransactionResource {
  final String _createdAt;
  final String _envelopeXdr;
  final String _hash;
  final int _ledgerSequence;
  final String _resultMetaXdr;
  final String _resultXdr;

  TransactionResource(this._createdAt, this._envelopeXdr, this._hash,
      this._ledgerSequence, this._resultMetaXdr, this._resultXdr);

  String get resultXdr => _resultXdr;

  String get resultMetaXdr => _resultMetaXdr;

  int get ledgerSequence => _ledgerSequence;

  String get hash => _hash;

  String get envelopeXdr => _envelopeXdr;

  String get createdAt => _createdAt;

  TransactionResource.fromJson(Map<String, dynamic> json)
      : this._createdAt = json['created_at'],
        this._envelopeXdr = json['envelope_xdr'],
        this._hash = json['hash'],
        this._ledgerSequence = json['ledger_sequence'],
        this._resultMetaXdr = json['result_meta_xdr'],
        this._resultXdr = json['result_xdr'];
}
