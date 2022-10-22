import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/animation.dart';
import 'package:monopoly_deal/game_components/effects/camera_zoom_effect.dart';

import 'card.dart';
import 'game_assets.dart';

class Deck extends PositionComponent with HasGameRef {
  Deck({
    required this.dealTargets,
  }) : super(
          position: Vector2(0, 0),
          size: Card.kCardSize,
          anchor: Anchor.center,
        );
  static const kCardAmount = 110;
  final List<PositionComponent> dealTargets;
  int _currentLoadedCardIndex = 0;

  @override
  Future<void>? onLoad() async {
    children.register<Card>();
    final cards = List.generate(
        kCardAmount,
        (index) => Card(
              id: index,
              position: size / 2 +
                  Vector2.all(1) * (kCardAmount / 2) -
                  Vector2.all(1) * index.toDouble(),
              priority: index,
            ));
    TimerComponent(
      period: 0.01,
      repeat: true,
      onTick: () async {
        if (_currentLoadedCardIndex < kCardAmount) {
          add(cards[_currentLoadedCardIndex++]);
        }
      },
    )
      ..add(RemoveEffect(delay: 1.3))
      ..addToParent(this);

    priority = 1;
    for (var d in dealTargets) {
      d.priority = 0;
    }
  }

  void deal() {
    game.children.query<CameraComponent>().first.add(
          CameraZoomEffect.to(
            Card.kCardSize * 7,
            CurvedEffectController(1, Curves.easeOutCubic),
          ),
        );
    var ti = dealTargets.iterator;
    if (!ti.moveNext()) {
      return;
    }
    var ci = children.query<Card>().reversed.iterator..moveNext();
    final fullDuration = (dealTargets.length * 5 + 1) * 0.3 + 1;
    for (var i = 0; i < dealTargets.length * 5; i++) {
      final d = (i + 1) * 0.3;
      final c = ci.current;
      final t = ti.current;
      c.addAll([
        RotateEffect.by(
          pi * 0.75 + Random(gameAssets.randomSeed()).nextInt(90) * pi / 180,
          EffectController(
              duration: 0.5, curve: Curves.easeOutCubic, startDelay: d),
        ),
        MoveEffect.to(
          t.position + c.size / 2,
          EffectController(
              duration: 0.5, curve: Curves.easeOutCubic, startDelay: d),
        ),
        TimerComponent(
          period: d + 0.2,
          onTick: () {
            c.priority = i;
          },
          removeOnFinish: true,
        ),
        TimerComponent(
          period: fullDuration,
          onTick: () {
            c.changeParent(t);
          },
          removeOnFinish: true,
        )
      ]);
      ci.moveNext();
      if (!ti.moveNext()) {
        ti = dealTargets.iterator..moveNext();
      }
    }
  }
}
