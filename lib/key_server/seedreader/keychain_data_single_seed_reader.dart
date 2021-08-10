import 'package:dart_sdk/key_server/seedreader/keychain_data_seed_reader.dart';
import 'package:dart_sdk/utils/statemachine/char_state.dart';
import 'package:dart_sdk/utils/statemachine/char_transition.dart';
import 'package:tuple/tuple.dart';

class KeychainDataSingleSeedReader extends KeychainDataSeedReader {
  String? reedSeed;

  @override
  Set<CharState> get states => (KeychainDataSeedReader.startToSeeStates
        ..addAll({
          CharState.withTransitions("'seed",
              List.of([CharTransition.get(Tuple2('"', "'seed'"), (char) {})])),
          CharState.withTransitions(
              "'seed'",
              List.of([
                CharTransition.basic(
                    ((value) => value != '"'), "'seed'", (char) {}),
                CharTransition.get(Tuple2('"', "seed_char"), (char) {})
              ])),
          CharState.withTransitions(
              "seed_char",
              List.of([
                CharTransition.basic(((value) => value != '"'), "seed_char",
                    (char) {
                  currentSeed += char;
                }),
                CharTransition.get(Tuple2('"', "end"), (char) {
                  reedSeed = reedSeed ?? currentSeed;
                  clearCurrentSeed();
                })
              ])),
          CharState.finall("end")
        }))
      .toSet();

  @override
  set startState(String _startState) {
    startState = _startState;
  }

  @override
  set states(Set<CharState> _states) {
    states = _states;
  }
}
