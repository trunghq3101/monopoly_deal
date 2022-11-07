import 'dart:math';

import 'package:flame/components.dart';

extension DoubleExt on double {
  Vector2 angleToVector2(double radius) =>
      Vector2(sin(this), cos(this)) * radius;
}
