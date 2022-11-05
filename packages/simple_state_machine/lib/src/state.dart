part of simple_state_machine;

class State {
  final String? debugName;
  final Map<Command, Transition> _transitions = {};

  State({this.debugName});

  void addTransition(MapEntry<Command, Transition> transition) {
    _transitions.addEntries([transition]);
  }

  State handle(Command command) {
    printDebug(debugName);
    final newState = _transitions.entries
            .firstWhereOrNull((e) => e.key == command)
            ?.value
            ._activate() ??
        this;
    printDebug(newState.debugName);
    return newState;
  }
}
