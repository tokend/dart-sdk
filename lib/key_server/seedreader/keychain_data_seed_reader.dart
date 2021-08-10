import 'package:dart_sdk/utils/statemachine/char_seequence_machine.dart';
import 'package:dart_sdk/utils/statemachine/char_state.dart';
import 'package:dart_sdk/utils/statemachine/char_transition.dart';
import 'package:tuple/tuple.dart';

abstract class KeychainDataSeedReader extends CharSequenceStateMachine {
  static const SEED_BUFFER_SIZE = 400;
  static var startToSeeStates = [
    CharState.withTransitions(
        "start",
        List.of([
          CharTransition.get(Tuple2('"', "'"), (char) {
            return false;
          })
        ])),
    CharState.withTransitions(
        "'",
        List.of([
          CharTransition.get(Tuple2('s', "'s"), (char) {
            return false;
          })
        ])),
    CharState.withTransitions(
        "'s",
        List.of([
          CharTransition.get(Tuple2('e', "'se"), (char) {
            return false;
          })
        ])),
    CharState.withTransitions(
        "'se",
        List.of([
          CharTransition.get(Tuple2('e', "'see"), (char) {
            return false;
          })
        ])),
    CharState.withTransitions(
        "'see",
        List.of([
          CharTransition.get(Tuple2('d', "'seed"), (char) {
            return false;
          })
        ])),
  ];

  @override
  String get startState => 'start';

  @override
  bool run(String input) {
    return super.run(input);
  }

  String currentSeed = "";

  clearCurrentSeed() {
    currentSeed = "";
  }
}
