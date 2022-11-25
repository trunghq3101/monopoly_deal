// ignore_for_file: avoid_print

import '../simple_state_machine.dart';

void printDebug(Object? s) {
  if (!Flags.debugMode) return;
  print(s);
}
