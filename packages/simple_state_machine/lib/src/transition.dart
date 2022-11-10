part of simple_state_machine;

abstract class Transition<T> {
  final T dest;
  Transition(this.dest);

  FutureOr<void> _activate(dynamic payload) {
    printDebug(runtimeType);
    return onActivate(payload);
  }

  FutureOr<void> onActivate(dynamic payload);
}
