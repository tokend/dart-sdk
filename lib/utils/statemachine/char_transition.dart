import 'package:tuple/tuple.dart';

class CharTransition {
  bool Function(String s) predicate;
  String newState;
  Function(String char) callback;

  String? char;
  CharTransition(String char, String newState, Function(String char) callback)
      : predicate = ((value) => char == value),
        newState = newState,
        callback = callback;

  CharTransition.get(
      Tuple2<String, String> transition, Function(String char) callback)
      : this(transition.item1, transition.item2, callback);

}
