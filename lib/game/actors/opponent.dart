import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:monopoly_deal/game/game.dart';

class Opponent extends Component with HasGameRef<BaseGame> {
  void pickUpCards({required List<CardBack> facingDownCardsByTopMost}) {
    const timeStep = 0.1;
    final destination = Vector2(0, -GameSize.visibleAfterDealing.y * 3.5);

    // pull the cards out
    for (var i = 0; i < facingDownCardsByTopMost.length; i++) {
      final card = facingDownCardsByTopMost[i];
      card.addAll([
        RotateEffect.to(
          0,
          DelayedEffectController(
            LinearEffectController(0.1),
            delay: timeStep * i,
          ),
        ),
        MoveEffect.to(
          destination,
          DelayedEffectController(
            CurvedEffectController(0.3, Curves.easeInCubic),
            delay: timeStep * i,
          ),
        ),
        RemoveEffect(delay: timeStep * i + 0.3),
      ]);
    }

    // take the cards to hand
    final cardsAmount = facingDownCardsByTopMost.length;
    final cardFrontCollection = facingDownCardsByTopMost
        .map((e) => CardFront(id: e.id)..addToParent(gameRef.world))
        .toList();
    _placingCardsInHand(
      cardFrontCollection: cardFrontCollection,
      timeStep: 0.1,
      animationDuration: 0.4,
      isFirstTime: true,
    );
  }

  void _placingCardsInHand({
    required List<CardFront> cardFrontCollection,
    required double timeStep,
    required double animationDuration,
    bool isFirstTime = false,
  }) {
    final initialPosition = Vector2(0, -GameSize.visibleAfterDealing.y * 3.5);
    final cardsAmount = cardFrontCollection.length;
    final needSmallerHand = cardsAmount <= 2;
    final handCurveWidth = needSmallerHand
        ? GameSize.visibleAfterDealing.x * 0.2
        : GameSize.visibleAfterDealing.x / 2;
    final handCurveStart =
        Vector2(-handCurveWidth / 2, -GameSize.visibleAfterDealing.y * 0.35);
    final handCurveEnd = handCurveStart + Vector2(handCurveWidth, 0);
    final handCurveRadius = needSmallerHand
        ? Radius.elliptical(handCurveWidth, handCurveWidth * 0.2)
        : Radius.elliptical(handCurveWidth, handCurveWidth / 2);
    final handCurve = Path()
      ..moveTo(handCurveStart.x, handCurveStart.y)
      ..arcToPoint(
        Offset(handCurveEnd.x, handCurveEnd.y),
        radius: handCurveRadius,
      );
    final spacing = handCurveWidth / (cardsAmount - 1);
    final pathMetrics = handCurve.computeMetrics().first;
    for (var i = 0; i < cardsAmount; i++) {
      final tangent = pathMetrics.getTangentForOffset(i * spacing)!;
      final inHandPosition = Vector2(tangent.position.dx, tangent.position.dy);
      if (isFirstTime) {
        cardFrontCollection[i].position = initialPosition;
      }
      cardFrontCollection[i]
        ..size = GameSize.cardInHand.size
        ..anchor = Anchor.center
        ..priority = GamePriority.hand.priority
        ..addAll([
          MoveEffect.to(
            inHandPosition,
            DelayedEffectController(
              CurvedEffectController(animationDuration, Curves.easeInOutCubic),
              delay: i * timeStep,
            ),
          ),
          RotateEffect.to(
            tangent.vector.direction,
            DelayedEffectController(
              CurvedEffectController(animationDuration, Curves.easeInOutCubic),
              delay: i * timeStep,
            ),
          )
        ]);
    }
  }
}
