part of simple_state_machine;

class State<T> {
  final T identifier;
  final Map<Command, Transition> _transitions = {};

  State(this.identifier);

  String get debugName => identifier.toString();

  void addTransitions(Map<Command, Transition> transitions) {
    _transitions.addAll(transitions);
  }
}
