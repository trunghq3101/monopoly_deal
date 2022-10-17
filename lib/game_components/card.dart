import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/game_components/effects/priority_effect.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';

class Card extends SvgComponent {
  Card({
    required super.svg,
    required super.position,
    required super.priority,
  }) : super(size: kCardSize, anchor: Anchor.center);

  static const kCardWidth = 1120.0;
  static const kCardHeight = 1584.0;
  static final kCardSize = Vector2(kCardWidth, kCardHeight);

  void deal({required Vector2 by, double delay = 0, int? priority}) {
    final rotation =
        pi * 0.75 + Random(gameAssets.randomSeed()).nextInt(90) * pi / 180;
    addAll([
      if (priority != null)
        PriorityEffect.to(
          priority,
          DelayedEffectController(
            EffectController(duration: 0.1),
            delay: delay + 0.1,
          ),
        ),
      RotateEffect.by(
        rotation,
        DelayedEffectController(
          EffectController(
            duration: 0.5,
            curve: Curves.easeOutCubic,
          ),
          delay: delay,
        ),
      ),
      MoveEffect.by(
        by,
        DelayedEffectController(
          EffectController(
            duration: 0.5,
            curve: Curves.easeOutCubic,
          ),
          delay: delay,
        ),
      ),
    ]);
  }
}
