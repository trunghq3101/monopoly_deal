import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

import '../game_assets.dart';

class CardDealEffect extends Component {
  CardDealEffect({
    required this.to,
    required this.delay,
    this.toPriority,
  });

  final Vector2 to;
  final double delay;
  final int? toPriority;

  @override
  Future<void>? onLoad() async {
    final rotation =
        pi * 0.75 + Random(gameAssets.randomSeed()).nextInt(90) * pi / 180;
    if (toPriority != null) {
      TimerComponent(
        period: delay + 0.2,
        onTick: () {
          parent?.priority = toPriority!;
        },
        removeOnFinish: true,
      ).addToParent(this);
    }
    parent?.addAll([
      RotateEffect.by(
        rotation,
        EffectController(
            duration: 0.5, curve: Curves.easeOutCubic, startDelay: delay),
      ),
      MoveEffect.to(
        to,
        EffectController(
            duration: 0.5, curve: Curves.easeOutCubic, startDelay: delay),
        onComplete: () {
          removeFromParent();
        },
      ),
    ]);
  }
}
