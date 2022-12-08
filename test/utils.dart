import 'dart:math';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

class StubMainGame extends FlameGame with HasTappableComponents {}

extension DoubleRound on double {
  double toFixed(int fractionDigits) {
    num mod = pow(10.0, fractionDigits);
    return ((this * mod).round().toDouble() / mod);
  }
}
