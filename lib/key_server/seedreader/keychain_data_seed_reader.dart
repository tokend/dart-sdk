import 'package:dart_sdk/utils/statemachine/char_seequence_machine.dart';
import 'package:dart_sdk/utils/statemachine/char_state.dart';
import 'package:dart_sdk/utils/statemachine/char_transition.dart';
import 'package:tuple/tuple.dart';

abstract class KeychainDataSeedReader extends CharSequenceStateMachine {
  KeychainDataSeedReader(Set<CharState> states, String startState)
      : super(states, startState);

  static const SEED_BUFFER_SIZE = 400;
  static var startToSeeStates = [
    CharState.withTransitions(
        "start", List.of([CharTransition.get(Tuple2('"', "'"), (char) {})])),
    CharState.withTransitions(
        "'", List.of([CharTransition.get(Tuple2('s', "'s"), (char) {})])),
    CharState.withTransitions(
        "'s", List.of([CharTransition.get(Tuple2('e', "'se"), (char) {})])),
    CharState.withTransitions(
        "'se", List.of([CharTransition.get(Tuple2('e', "'see"), (char) {})])),
    CharState.withTransitions(
        "'see", List.of([CharTransition.get(Tuple2('d', "'seed"), (char) {})])),
  ];

  @override
  String get startState => 'start';

  @override
  bool run(String input) {
    var result = super.run(input);
    throw UnimplementedError();
  }

  List<String> currentSeed = <String>[];

  clearCurrentSeed() {
    currentSeed.fillRange(0, currentSeed.length, '0');
    currentSeed.clear();
  }
}
