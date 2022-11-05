part of simple_state_machine;

abstract class Transition {
  State _activate() {
    printDebug(runtimeType);
    return onActivate();
  }

  State onActivate();
}
