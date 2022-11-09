part of simple_state_machine;

abstract class Transition {
  final StateMachine stateMachine;

  Transition(this.stateMachine);

  State? _activate(Command command) {
    printDebug(runtimeType);
    return onActivate(command);
  }

  State? onActivate(Command command);
}
