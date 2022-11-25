import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/state_machine/state_machine.dart';

class Player extends Component with HasGameRef<BaseGame> {
  Player({required this.broadcaster});

  final PlayerBroadcaster broadcaster;
  late final _handStateMachine = StateMachine<HandState, GameEvent>();
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
      onTick: () => _handStateMachine.handle(const Event(GameEvent.handUp)),
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

  void transformTapCardFrontEvent(Event<GameEvent> event) {
    final transformedEvent = Event(
      _previewingCardId == event.payload
          ? GameEvent.tapPreviewingCard
          : GameEvent.tapCardInHand,
      event.payload,
    );
    _handStateMachine.handle(transformedEvent);
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
    _setupStateMachine();
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

  void handle(Event<GameEvent> event) {
    _handStateMachine.handle(event);
  }

  void _setupStateMachine() {
    _handStateMachine.setup({
      HandState.initial: {
        GameEvent.handUp: EventAction(
          (event) => enableHandUpOverlay(),
          HandState.handUp,
        ),
      },
      HandState.handUp: {
        GameEvent.tapHandUpOverlay: EventAction(
          (event) => letTheHandDown(),
          HandState.handDown,
        ),
        GameEvent.tapCardFront: EventAction(
          (event) => moveSelectedCardToPreviewingPosition(event.payload),
          HandState.previewing,
        ),
      },
      HandState.handDown: {
        GameEvent.tapHandDownRegion: EventAction(
          (event) => letTheHandUp(),
          HandState.handUp,
        ),
      },
      HandState.previewing: {
        GameEvent.tapCardFront: EventAction(
          (event) => transformTapCardFrontEvent(event as Event<GameEvent>),
          HandState.previewing,
        ),
        GameEvent.tapCardInHand: EventAction(
          (event) => swapPreviewingCard(event.payload),
          HandState.previewing,
        ),
        GameEvent.tapPreviewingCard: EventAction(
          (event) => movePreviewingCardBackToHand(),
          HandState.handUp,
        ),
      }
    });
  }
}

enum HandState { initial, handUp, handDown, previewing }

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
