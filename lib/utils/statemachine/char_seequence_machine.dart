import 'package:dart_sdk/utils/statemachine/char_state.dart';

abstract class CharSequenceStateMachine {
  Set<CharState> states;
  String startState;

  CharSequenceStateMachine(this.states, this.startState);

  bool run(String input) {
    var statesMap = Map() as Map<String, CharState>;

    states.forEach((state) {
      statesMap[state.name] = state;
    });

    var startState = statesMap[this.startState];
    var state = startState;

    for (int i = 0; i < input.length; i++) {
      var s = state?.doTransition(input[i]);
      if (s == null) {
        state = startState;
      }
      var newState = statesMap[s];
      if (newState == null) {
        throw ArgumentError('State $s not found');
      }

      state = newState;

      if (state.isFinal) {
        return true;
      }
    }

    return false;
  }
}
