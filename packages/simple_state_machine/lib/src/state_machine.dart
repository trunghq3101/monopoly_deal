part of simple_state_machine;

class StateMachine<T> {
  late State<T> _state;
  final _states = <T, State<T>>{};

  State<T> state(T identifier) {
    if (!_states.containsKey(identifier)) {
      throw ArgumentError.value(
          identifier, 'identifier', 'Not exist state identifier');
    }
    return _states[identifier]!;
  }

  void start(T identifier) {
    _state = newState(identifier);
  }

  State<T> newState(T identifier) {
    if (_states.containsKey(identifier)) {
      throw ArgumentError.value(
          identifier, 'identifier', 'Duplicated state identifier');
    }
    final state = State<T>(identifier);
    _states[identifier] = state;
    return state;
  }

  void onCommand(Command command) {
    final t = _state._transitions.entries
        .firstWhereOrNull((e) => e.key == command)
        ?.value;
    if (t != null) {
      if (!_states.containsKey(t.dest)) {
        throw ArgumentError.value(
            t.dest, 'destination', 'Not exist destination state');
      }
      t._activate(command.payload);
      _state = _states[t.dest]!;
    }
  }
}