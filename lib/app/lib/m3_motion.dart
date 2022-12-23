import 'package:flutter/animation.dart';

enum M3Easing {
  emphasizedDecelerate(Cubic(0.05, 0.7, 0.1, 1.0));

  final Cubic cubic;

  const M3Easing(this.cubic);
}

enum M3Duration {
  short4(Duration(milliseconds: 200)),
  medium4(Duration(milliseconds: 400));

  final Duration duration;

  const M3Duration(this.duration);
}
