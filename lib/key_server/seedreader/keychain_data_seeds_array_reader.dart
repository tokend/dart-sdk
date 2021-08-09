import 'package:dart_sdk/key_server/seedreader/keychain_data_seed_reader.dart';
import 'package:dart_sdk/utils/statemachine/char_state.dart';
import 'package:dart_sdk/utils/statemachine/char_transition.dart';
import 'package:tuple/tuple.dart';

class KeychainDataSeedsArrayReader extends KeychainDataSeedReader {
  var reedSeeds = <String>[];

  @override
  Set<CharState> get states => (KeychainDataSeedReader.startToSeeStates
        ..addAll({
          CharState.withTransitions("'seed",
              List.of([CharTransition.get(Tuple2("s", "'seeds"), (char) {})])),
          CharState.withTransitions("'seeds",
              List.of([CharTransition.get(Tuple2('"', "'seeds'"), (char) {})])),
          CharState.withTransitions(
              "'seeds'",
              List.of([
                CharTransition.basic(
                    ((value) => value != "["), "'seeds'", (char) {}),
                CharTransition.get(Tuple2('[', "seeds_array_start"), (char) {})
              ])),
          CharState.withTransitions(
              "seeds_array_start",
              List.of([
                CharTransition.basic(((value) {
                  return value != '"';
                }), "seeds_array_start'", (char) {}),
                CharTransition.get(Tuple2('"', "seed_char"), (char) {})
              ])),
          CharState.withTransitions(
              "seed_char",
              List.of([
                CharTransition.basic(
                    ((value) {
                      return value != '"';
                    }),
                    "seed_char",
                    (char) {
                      currentSeed += char;
                    }),
                CharTransition.get(Tuple2('"', "seeds_array_item_end"), (char) {
                  reedSeeds.add(currentSeed);
                  clearCurrentSeed();
                })
              ])),
          CharState.withTransitions(
              "seeds_array_item_end",
              List.of([
                CharTransition.basic(((value) => value != '"' && value != "]"),
                    "seeds_array_item_end'", (char) {}),
                CharTransition.get(Tuple2(']', "end"), (char) {}),
                CharTransition.get(Tuple2('"', "seed_char"), (char) {})
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
