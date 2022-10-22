import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/animation.dart';
import 'package:monopoly_deal/game_components/effects/camera_zoom_effect.dart';

import 'card.dart';
import 'effects/card_deal_effect.dart';

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
    children.register<TimerComponent>();
    final cards = List.generate(
        kCardAmount,
        (index) => Card(
              id: index,
              position: size / 2 +
                  Vector2.all(1) * (kCardAmount / 2) -
                  Vector2.all(1) * index.toDouble(),
              priority: index,
            ));
    // addAll(cards);
    final init = TimerComponent(
      period: 0.01,
      repeat: true,
      onTick: () async {
        if (_currentLoadedCardIndex < kCardAmount) {
          add(cards[_currentLoadedCardIndex++]);
        }
        // if (_currentLoadedCardIndex == kCardAmount - 1) {
        //   children.query<TimerComponent>().first.removeFromParent();
        // }
      },
    )..addToParent(this);
    TimerComponent(
      period: 1.3,
      onTick: () {
        remove(init);
      },
      removeOnFinish: true,
    ).addToParent(this);
  }

  void deal() {
    game.children.query<CameraComponent>().first.add(
          CameraZoomEffect.to(
            Card.kCardSize * 7,
            EffectController(duration: 1, curve: Curves.easeOutCubic),
          ),
        );
    var t = dealTargets.iterator;
    if (!t.moveNext()) {
      return;
    }
    var c = children.query<Card>().reversed.iterator..moveNext();
    for (var i = 0; i < dealTargets.length * 5; i++) {
      c.current.add(
        CardDealEffect(
          to: t.current.position + (c.current.size / 2),
          delay: (i + 1) * 0.3,
          toPriority: i,
        ),
      );
      c.moveNext();
      if (!t.moveNext()) {
        t = dealTargets.iterator..moveNext();
      }
    }
  }
}
