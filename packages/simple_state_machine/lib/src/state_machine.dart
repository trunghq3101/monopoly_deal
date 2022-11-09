part of simple_state_machine;

class StateMachine<T> {
  late State _state;
  final _states = <T, State<T>>{};

  State? state(T identifier) => _states[identifier];

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

  void addTransition(T from, MapEntry<Command, Transition> transition) {
    if (!_states.containsKey(from)) {
      throw ArgumentError.value(from, 'from', 'Not existed identifier');
    }
    _states[from]!.addTransition(transition);
  }

  void onCommand(Command command) {
    _state = _state.handle(command);
  }
}
