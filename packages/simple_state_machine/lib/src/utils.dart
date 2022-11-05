import '../simple_state_machine.dart';

void printDebug(Object? s) {
  if (!Flags.debugMode) return;
  print(s);
}
