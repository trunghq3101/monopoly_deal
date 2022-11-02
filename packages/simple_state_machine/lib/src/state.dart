import 'package:simple_state_machine/src/extensions.dart';

import 'command.dart';
import 'transition.dart';

class State {
  final Map<Command, Transition> _transitions = {};

  void addTransition(MapEntry<Command, Transition> transition) {
    _transitions.addEntries([transition]);
  }

  State handle(Command command) {
    return _transitions.entries
            .firstWhereOrNull((e) => e.key == command)
            ?.value
            .activate() ??
        this;
  }
}
