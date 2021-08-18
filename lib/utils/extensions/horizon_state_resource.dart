import 'dart:math';

import 'package:dart_sdk/api/v3/info/model/HorizonStateResource.dart';
import 'package:dart_wallet/network_params.dart';

extension HorizonStateResourceToNetworkParams on HorizonStateResource {
  NetworkParams toNetworkParams() {
    var precision = log(this.data.precision.toDouble()) ~/ ln10;
    return NetworkParams(this.data.networkPassphrase, precision: precision);
  }
}
