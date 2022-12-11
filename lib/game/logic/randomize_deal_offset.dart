import 'dart:math';

import 'package:flame/components.dart';

class RandomizeDealOffset {
  Vector2 generate() {
    final noise = SimplexNoise(Random());
    final randomValue =
        noise.noise2D(Random().nextDouble() * 40, Random().nextDouble() * 20) *
            100;
    return Vector2.all(randomValue);
  }
}
