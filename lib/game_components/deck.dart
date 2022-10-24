import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/animation.dart';

import 'card.dart';
import 'effects/camera_zoom_effect.dart';
import 'game_assets.dart';

class Deck extends PositionComponent with HasGameRef {
  Deck({
    required this.dealTargets,
    required this.cardSprite,
  }) : super(
          position: Vector2(0, 0),
          size: Card.kCardSize,
          anchor: Anchor.center,
        );
  static const kCardAmount = 106;
  final List<PositionComponent> dealTargets;
  final Sprite cardSprite;
  int _currentLoadedCardIndex = 0;

  @override
  Future<void>? onLoad() async {
    children.register<Card>();
    final cardIds =
        List.generate(kCardAmount, (index) => index, growable: false)
          ..shuffle();
    var p = 0;
    final cards = cardIds
        .map((id) => Card(
              id: id,
              sprite: cardSprite,
              position: size / 2 +
                  Vector2.all(Card.kCardWidth / 1000) * (kCardAmount / 2) -
                  Vector2.all(Card.kCardWidth / 1000) * p.toDouble(),
              priority: p++,
            ))
        .toList();
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
            LinearEffectController(1),
          ),
        );
    var ti = dealTargets.iterator;
    if (!ti.moveNext()) {
      return;
    }
    var ci = children.query<Card>().reversed.iterator..moveNext();
    final fullDuration = dealTargets.length * 5 * 0.3 + 0.5;
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
            c
              ..changeParent(t)
              ..removed.then((value) => c.position = t.size / 2);
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
