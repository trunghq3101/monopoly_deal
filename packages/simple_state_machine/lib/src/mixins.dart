part of simple_state_machine;

mixin HasStateMachine {
  final List<StateMachine> _stateMachines = [];

  StateMachine newMachine<T>(Map<T, Map<Command, Transition>> states) {
    final sm = StateMachine<T>();
    for (var s in states.entries) {
      sm.state(s.key).addTransitions(s.value);
    }
    _stateMachines.add(sm);
    return sm;
  }

  void onCommand(Command command) {
    for (var m in _stateMachines) {
      m.onCommand(command);
    }
  }
}
