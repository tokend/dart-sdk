import 'package:dart_sdk/utils/statemachine/char_transition.dart';

abstract class CharState {
  String name;
  bool isFinal;

  CharState(this.name, this.isFinal);

  String? doTransition(String char);

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    return other is CharState && this.name == other.name;
  }

  @override
  String toString() {
    return "CharState($name){final=$isFinal}@$hashCode";
  }

  static CharState withTransitions(
      String name, List<CharTransition> transitions) {
    return _AnonymousCharState(name, transitions.isEmpty, doTransition: (char) {
      CharTransition? transition;
      transitions.forEach((tr) {
        if (tr.predicate(char)) {
          transition = tr;
          transition!.callback.call(char);
        }
      });
      return (transition)?.newState;
    });
  }

  static CharState finall(String name) {
    return _AnonymousCharState(name, true, doTransition: (char) => null);
  }
}

class _AnonymousCharState implements CharState {
  _AnonymousCharState(this.name, this.isFinal,
      {required String? doTransition(String char)})
      : _doTransition = doTransition;

  @override
  bool isFinal;

  @override
  String name;

  String? Function(String char) _doTransition;

  @override
  String? doTransition(String char) => _doTransition(char);
}
