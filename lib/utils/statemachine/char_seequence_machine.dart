import 'dart:collection';

import 'package:dart_sdk/utils/statemachine/char_state.dart';

abstract class CharSequenceStateMachine {
  abstract Set<CharState> states;
  abstract String startState;

  bool run(String input) {
    var statesMap = HashMap<String, CharState>();

    states.forEach((state) {
      statesMap[state.name] = state;
    });

    var startState = statesMap[this.startState];
    var state = startState;

    for (int i = 0; i < input.length; i++) {
      var key = state?.doTransition(input[i]);
      state = statesMap[key];

      if (state?.name == null) {
        state = startState;
      }

      if (state?.isFinal == true) {
        return true;
      }
    }

    return false;
  }
}
