# dart_sdk

TokenD Dart SDK This library facilitates interaction with TokenD-based system from Flutter applications including Android and IOS apps.

## Installation
To add SDK to your project add following dependency to your `pubspec.yaml` file:
```yaml
dependencies:
  ...
  dart_wallet:
    git:
      url: https://github.com/tokend/dart-wallet
      ref: dev
  ...
```

## Usage
This SDK uses some null unsafe libraries. To avoid build errors add ``--no-sound-null-safety``  flag in your configuration.
### Setting up and making requests
```dart
const TOKEND_URL = 'https://api.testnet.tokend.org';

var api = TokenDApi(TOKEND_URL);

// Use TokenDApi facade members(documents, wallets, v3.keyValue, v3.signers, info, transactions) to access particular endpoints.
var systemInfo = await api.info.getSystemInfo());
var wallets = await api.wallets.getById(walletId));

// Use KeyServer instance to work with key server
var keyServer = KeyServer(api.wallets);
var walletInfo = await keyServer.getWalletInfo(email, password);

// Any endpoint can be reached using custom requests service
var response = await api.getService().get('any_endpoint/'))['data'];
```

## Documentation
Visit our [Docs](https://docs.tokend.io/) to get information on working with TokenD.