import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:monopoly_deal/game/game.dart';

class Player extends Component with HasGameReference<BaseGame> {
  Player({required this.broadcaster});

  final PlayerBroadcaster broadcaster;

  void _pickUpCards({required List<CardBack> facingDownCardsByTopMost}) {
    const timeStep = 0.1;

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
          Vector2(0, GameSize.visibleAfterDealing.y * 1.5),
          DelayedEffectController(
            CurvedEffectController(0.3, Curves.easeInCubic),
            delay: timeStep * i,
          ),
        ),
        RemoveEffect(delay: timeStep * i + 0.3),
      ]);
    }

    // take the cards to hand
    final handCurveWidth = GameSize.visibleAfterDealing.x / 2;
    final handCurveStart =
        Vector2(-handCurveWidth / 2, GameSize.visibleAfterDealing.y * 0.35);
    final handCurveEnd = handCurveStart + Vector2(handCurveWidth, 0);
    final handCurveRadius =
        Radius.elliptical(handCurveWidth, handCurveWidth / 2);
    final handCurve = Path()
      ..moveTo(handCurveStart.x, handCurveStart.y)
      ..arcToPoint(
        Offset(handCurveEnd.x, handCurveEnd.y),
        radius: handCurveRadius,
      );
    final cardsAmount = facingDownCardsByTopMost.length;
    final spacing = handCurveWidth / (cardsAmount - 1);
    final pathMetrics = handCurve.computeMetrics().first;
    for (var i = 0; i < cardsAmount; i++) {
      final tangent = pathMetrics.getTangentForOffset(i * spacing)!;
      final initialPosition = Vector2(0, GameSize.visibleAfterDealing.y * 1.3);
      final inHandPosition = Vector2(tangent.position.dx, tangent.position.dy);
      final c = CardFront(id: facingDownCardsByTopMost[i].id)
        ..size = GameSize.cardInHand.size
        ..position = initialPosition
        ..angle = tangent.vector.direction
        ..anchor = Anchor.center
        ..addToParent(game.world);
      MoveEffect.to(
        inHandPosition,
        DelayedEffectController(
          CurvedEffectController(0.4, Curves.easeInOutCubic),
          delay: i * timeStep,
        ),
      ).addToParent(c);
    }
  }

  void _listenToBroadcaster() {
    switch (broadcaster.event) {
      case PlayerEvent.tapPickUpRegion:
        _pickUpCards(facingDownCardsByTopMost: broadcaster.aboutToPickUpCards!);
        break;
      default:
    }
  }

  @override
  void onMount() {
    broadcaster.addListener(_listenToBroadcaster);
  }

  @override
  void onRemove() {
    broadcaster.removeListener(_listenToBroadcaster);
  }
}

enum PlayerEvent {
  tapPickUpRegion,
}

class PlayerBroadcaster extends ChangeNotifier {
  PlayerEvent? event;
  List<CardBack>? aboutToPickUpCards;

  void tapPickUpRegion({required List<CardBack> withCards}) {
    event = PlayerEvent.tapPickUpRegion;
    aboutToPickUpCards = withCards;
    notifyListeners();
  }
}
