part of simple_state_machine;

class StateMachine {
  late State _state;

  void start(State initialState) {
    _state = initialState;
  }

  void onCommand(Command command) {
    _state = _state.handle(command);
  }
}
