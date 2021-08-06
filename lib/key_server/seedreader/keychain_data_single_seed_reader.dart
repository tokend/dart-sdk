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
              List.of([CharTransition.get(Tuple2('"', "'seed"), (char) {})])),
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
                CharTransition.basic(((value) => value != '"'), "seed_char'",
                    (char) {
                  currentSeed.add(char);
                  // Prevent array copy on ensuring capacity
                  if (currentSeed.length >=
                      KeychainDataSeedReader.SEED_BUFFER_SIZE / 4) {
                    clearCurrentSeed();
                  }
                }),
                CharTransition.get(Tuple2('"', "end"), (char) {
                  currentSeed.forEach((element) {
                    reedSeed = reedSeed ?? "" + element;
                  });
                  clearCurrentSeed();
                })
              ])),
          CharState.finall("end")
        }))
      .toSet();
}
