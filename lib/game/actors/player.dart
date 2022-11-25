import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:monopoly_deal/game/game.dart';

class Player extends Component with HasGameRef<BaseGame> {
  Player({required this.broadcaster});

  final PlayerBroadcaster broadcaster;
  late final HandStateMachine _handStateMachine = HandStateMachine(this);
  int? _previewingCardId;
  late final HandUpOverlay _handUpOverlay;
  late final HandDownRegion _handDownRegion;

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
      CardFront(
        id: facingDownCardsByTopMost[i].id,
      )
        ..size = GameSize.cardInHand.size
        ..position = initialPosition
        ..angle = tangent.vector.direction
        ..anchor = Anchor.center
        ..priority = GamePriority.hand.priority
        ..addToParent(gameRef.world)
        ..add(MoveEffect.to(
          inHandPosition,
          DelayedEffectController(
            CurvedEffectController(0.4, Curves.easeInOutCubic),
            delay: i * timeStep,
          ),
        ));
    }
    add(TimerComponent(
      onTick: () => _handStateMachine.changeState(HandState.handUp),
      period: cardsAmount * timeStep + 0.4,
      removeOnFinish: true,
    ));
  }

  static const handDownOffset = 900.0;

  void letTheHandDown() {
    _handUpOverlay.disable();
    _handDownRegion.enable();
    final cardsInHand = CardFront.findAll(gameRef);
    for (var c in cardsInHand) {
      MoveEffect.by(Vector2(0, handDownOffset), LinearEffectController(0.1))
          .addToParent(c);
    }
  }

  void letTheHandUp() {
    _handDownRegion.disable();
    _handUpOverlay.enable();
    final cardsInHand = CardFront.findAll(gameRef);
    for (var c in cardsInHand) {
      MoveEffect.by(Vector2(0, -handDownOffset), LinearEffectController(0.1))
          .addToParent(c);
    }
  }

  void moveSelectedCardToPreviewingPosition(int cardId) {
    CardFront.findById(gameRef, cardId).moveToPreviewingPosition();
    _previewingCardId = cardId;
  }

  void swapPreviewingCard(int cardId) {
    movePreviewingCardBackToHand();
    moveSelectedCardToPreviewingPosition(cardId);
  }

  void movePreviewingCardBackToHand() {
    CardFront.findById(gameRef, _previewingCardId!).moveBackToHand();
    _previewingCardId = null;
  }

  void enableHandUpOverlay() {
    _handUpOverlay.enable();
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
    _handDownRegion = HandDownRegion()
      ..position = Vector2(0, GameSize.visibleAfterDealing.y * 0.5)
      ..size = Vector2(
          GameSize.visibleAfterDealing.x, GameSize.visibleAfterDealing.y * 0.08)
      ..anchor = Anchor.bottomCenter
      ..priority = GamePriority.handUpRegion.priority
      ..addToParent(gameRef.world);
    _handUpOverlay = HandUpOverlay()
      ..position = Vector2.zero()
      ..size = Vector2.all(10000)
      ..anchor = Anchor.center
      ..addToParent(gameRef.world);
  }

  @override
  void onRemove() {
    broadcaster.removeListener(_listenToBroadcaster);
  }

  void handle(HandEvent event) {
    _handStateMachine.handle(event);
  }
}

enum HandState { initial, handUp, handDown, previewing }

class HandEvent extends Equatable {
  final Type eventType;
  final EventSender senderId;
  final dynamic payload;

  const HandEvent(this.eventType, this.senderId, [this.payload]);

  @override
  List<Object?> get props => [eventType, senderId];
}

class HandStateMachine {
  HandState _handState = HandState.initial;
  final Player player;

  HandStateMachine(this.player);

  void changeState(HandState state) {
    switch (state) {
      case HandState.handUp:
        player.enableHandUpOverlay();
        _handState = state;
        break;
      default:
    }
  }

  void handle(HandEvent event) {
    switch (_handState) {
      case HandState.handUp:
        if (event == const HandEvent(TapDownEvent, EventSender.handUpOverlay)) {
          player.letTheHandDown();
          _handState = HandState.handDown;
        } else if (event ==
            const HandEvent(TapDownEvent, EventSender.cardFront)) {
          player.moveSelectedCardToPreviewingPosition(event.payload);
          _handState = HandState.previewing;
        }
        break;
      case HandState.handDown:
        if (event ==
            const HandEvent(TapDownEvent, EventSender.handDownRegion)) {
          player.letTheHandUp();
          _handState = HandState.handUp;
        }
        break;
      case HandState.previewing:
        if (event == const HandEvent(TapDownEvent, EventSender.cardFront)) {
          if (player._previewingCardId == event.payload) {
            player.movePreviewingCardBackToHand();
            _handState = HandState.handUp;
          } else {
            player.swapPreviewingCard(event.payload);
            _handState = HandState.previewing;
          }
        }
        break;
      default:
    }
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
