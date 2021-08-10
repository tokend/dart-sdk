import 'package:dart_sdk/utils/statemachine/char_seequence_machine.dart';
import 'package:dart_sdk/utils/statemachine/char_state.dart';
import 'package:dart_sdk/utils/statemachine/char_transition.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuple/tuple.dart';

class _AnonymousCatsMachine extends CharSequenceStateMachine {
  @override
  String startState = "start";

  @override
  Set<CharState> states = Set.of([
    CharState.withTransitions(
        "start", List.of([CharTransition.get(Tuple2("c", "c"), (char) {})])),
    CharState.withTransitions(
        "c", List.of([CharTransition.get(Tuple2("a", "ca"), (char) {})])),
    CharState.withTransitions(
        "ca", List.of([CharTransition.get(Tuple2("t", "cat"), (char) {})])),
    CharState.withTransitions(
        "cat", List.of([CharTransition.get(Tuple2("s", "cats"), (char) {})])),
    CharState.finall("cats")
  ]);
}

var catsMachine = _AnonymousCatsMachine();

void main() {
  test('reach final state', () async {
    var input = "We have a categorized list of cats and dogs";

    expect(true, catsMachine.run(input));
  });

  test('did not reach final state', () async {
    var input = "catScaOcCATS";

    expect(false, catsMachine.run(input));
  });
}
