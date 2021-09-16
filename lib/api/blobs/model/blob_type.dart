import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

class Types {
  static Map<BlobType, int> types = {
    BlobType.ASSET_DESCRIPTION: 1,
    BlobType.FUND_OVERVIEW: 2,
    BlobType.FUND_UPDATE: 4,
    BlobType.NAV_UPDATE: 8,
    BlobType.FUND_DOCUMENT: 16,
    BlobType.ALPHA: 32,
    BlobType.BRAVO: 64,
    BlobType.CHARLIE: 128,
    BlobType.DELTA: 256,
    BlobType.TOKEN_TERMS: 512,
    BlobType.TOKEN_METRICS: 1024,
    BlobType.KYC_FORM: 2048,
    BlobType.KYC_ID_DOCUMENT: 4096,
    BlobType.KYC_POA: 8192,
    BlobType.IDENTITY_MIND_REJECT: 16384
  };

  static BlobType? fromName(String name) {
    BlobType? returnedType;
    BlobType.values.forEach((type) {
      if (name == describeEnum(type)) returnedType = type;
    });
    return returnedType;
  }

  static Tuple2<BlobType, int> fromValue(int value) {
    var key, value;
    key = types.keys.firstWhere((blobType) => types[blobType] == value);
    value = types[key];
    return Tuple2(key, value);
  }
}

enum BlobType {
  ASSET_DESCRIPTION,
  FUND_OVERVIEW,
  FUND_UPDATE,
  NAV_UPDATE,
  FUND_DOCUMENT,
  ALPHA,
  BRAVO,
  CHARLIE,
  DELTA,
  TOKEN_TERMS,
  TOKEN_METRICS,
  KYC_FORM,
  KYC_ID_DOCUMENT,
  KYC_POA,
  IDENTITY_MIND_REJECT
}
