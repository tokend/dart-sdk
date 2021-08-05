import 'package:dart_sdk/key_server/seedreader/keychain_data_seed_reader.dart';
import 'package:dart_sdk/utils/statemachine/char_state.dart';

class KeychainDataSeedsArrayReader extends KeychainDataSeedReader {
  KeychainDataSeedsArrayReader(Set<CharState> states, String startState)
      : super(states, startState);

  final reedSeeds = "";
}
