import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/game_components/effects/priority_effect.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';

class Card extends PositionComponent {
  Card({
    required this.id,
    required super.position,
    required super.priority,
    Vector2? size,
  }) : super(size: size ?? kCardSize, anchor: Anchor.center);

  static const kCardWidth = 1120.0;
  static const kCardHeight = 1584.0;
  static final kCardSize = Vector2(kCardWidth, kCardHeight);

  final int id;

  @override
  void render(Canvas canvas) {
    final size = this.size.toSize();
    Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 120;
    paintStroke.color = const Color.fromARGB(255, 255, 255, 255);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(size.width * 0.07),
      ),
      paintStroke,
    );

    Paint paintFill = Paint()..style = PaintingStyle.fill;
    paintFill.color = const Color(0xffC4C4C4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(size.width * 0.07),
      ),
      paintFill,
    );
  }

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

  void flyOut(int index) {
    addAll([
      RotateEffect.to(0, EffectController(duration: 0.5)),
      MoveEffect.by(Vector2(index * 800, 0), EffectController(duration: 0.5)),
      MoveEffect.by(
        Vector2(-index * 800, 4000),
        EffectController(startDelay: 0.5, duration: 0.5),
      ),
    ]);
  }
}
