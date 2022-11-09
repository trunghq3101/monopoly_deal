part of simple_state_machine;

class State<T> {
  final T identifier;
  final Map<Command, Transition> _transitions = {};

  State(this.identifier);

  String get debugName => identifier.toString();

  void addTransition(MapEntry<Command, Transition> transition) {
    _transitions.addEntries([transition]);
  }

  State handle(Command command) {
    printDebug(debugName);
    final newState = _transitions.entries
            .firstWhereOrNull((e) => e.key == command)
            ?.value
            ._activate(command) ??
        this;
    printDebug(newState.debugName);
    return newState;
  }
}
