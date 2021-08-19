class HorizonStateResource {
  final Data data;

  HorizonStateResource(this.data);

  HorizonStateResource.fromJson(Map<String, dynamic> json)
      : this.data = Data.fromJson(json['data']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  String id;
  String type;
  Core core;
  String coreVersion;
  String currentTime;
  int currentTimeUnix;
  String environmentName;
  Core history;
  Core historyV2;
  String masterAccountId;
  String networkPassphrase;
  int precision;
  int txExpirationPeriod;
  String xdrRevision;

  Data(
      this.id,
      this.type,
      this.core,
      this.coreVersion,
      this.currentTime,
      this.currentTimeUnix,
      this.environmentName,
      this.history,
      this.historyV2,
      this.masterAccountId,
      this.networkPassphrase,
      this.precision,
      this.txExpirationPeriod,
      this.xdrRevision);

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        core = Core.fromJson(json['core']),
        coreVersion = json['core_version'],
        currentTime = json['current_time'],
        currentTimeUnix = json['current_time_unix'],
        environmentName = json['environment_name'],
        history = Core.fromJson(json['history']),
        historyV2 = new Core.fromJson(json['history_v2']),
        masterAccountId = json['master_account_id'],
        networkPassphrase = json['network_passphrase'],
        precision = json['precision'],
        txExpirationPeriod = json['tx_expiration_period'],
        xdrRevision = json['xdr_revision'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.core != null) {
      data['core'] = this.core.toJson();
    }
    data['core_version'] = this.coreVersion;
    data['current_time'] = this.currentTime;
    data['current_time_unix'] = this.currentTimeUnix;
    data['environment_name'] = this.environmentName;
    if (this.history != null) {
      data['history'] = this.history.toJson();
    }
    if (this.historyV2 != null) {
      data['history_v2'] = this.historyV2.toJson();
    }
    data['master_account_id'] = this.masterAccountId;
    data['network_passphrase'] = this.networkPassphrase;
    data['precision'] = this.precision;
    data['tx_expiration_period'] = this.txExpirationPeriod;
    data['xdr_revision'] = this.xdrRevision;
    return data;
  }
}

class Core {
  String lastLedgerIncreaseTime;
  int latest;
  int oldestOnStart;

  Core(this.lastLedgerIncreaseTime, this.latest, this.oldestOnStart);

  Core.fromJson(Map<String, dynamic> json)
      : lastLedgerIncreaseTime = json['last_ledger_increase_time'],
        latest = json['latest'],
        oldestOnStart = json['oldest_on_start'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_ledger_increase_time'] = this.lastLedgerIncreaseTime;
    data['latest'] = this.latest;
    data['oldest_on_start'] = this.oldestOnStart;
    return data;
  }
}
