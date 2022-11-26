import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/state_machine/state_machine.dart';

class Player extends Component with HasGameRef<BaseGame> {
  final _handStateMachine = StateMachine<HandState, GameEvent>();
  late final HandUpOverlay _handUpOverlay;
  late final HandDownRegion _handDownRegion;
  late final CardPlayButton _cardPlayButton;
  int? _previewingCardId;

  void pickUpCards({required List<CardBack> facingDownCardsByTopMost}) {
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
    final cardsInHand = CardFront.findCardsInHand(gameRef);
    for (var c in cardsInHand) {
      MoveEffect.by(Vector2(0, handDownOffset), LinearEffectController(0.1))
          .addToParent(c);
    }
  }

  void letTheHandUp() {
    _handDownRegion.disable();
    _handUpOverlay.enable();
    final cardsInHand = CardFront.findCardsInHand(gameRef);
    for (var c in cardsInHand) {
      MoveEffect.by(Vector2(0, -handDownOffset), LinearEffectController(0.1))
          .addToParent(c);
    }
  }

  void moveSelectedCardToPreviewingPosition({required int selectedCardId}) {
    CardFront.findById(gameRef, selectedCardId).moveToPreviewingPosition();
    _previewingCardId = selectedCardId;
  }

  void swapPreviewingCard({required int selectedCardId}) {
    movePreviewingCardBackToHand();
    moveSelectedCardToPreviewingPosition(selectedCardId: selectedCardId);
  }

  void movePreviewingCardBackToHand() {
    CardFront.findById(gameRef, _previewingCardId!).moveBackToHand();
    _previewingCardId = null;
  }

  void enableHandUpOverlay() {
    _handUpOverlay.enable();
  }

  void playPreviewingCard() {
    if (_previewingCardId == null) return;
    final previewingCard = CardFront.findById(gameRef, _previewingCardId!);
    previewingCard
      ..priority = 0
      ..changePlace(CardPlace.onTheTable)
      ..addAll([
        SizeEffect.to(GameSize.cardOnTable.size, LinearEffectController(0.2)),
        ScaleEffect.to(Vector2.all(1), LinearEffectController(0.2)),
        MoveEffect.to(Vector2(0, 700), LinearEffectController(0.2)),
      ]);
  }

  @override
  void onMount() {
    _setupStateMachine();
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
    _cardPlayButton = CardPlayButton()
      ..size = Vector2(200, 300)
      ..position = Vector2(GameSize.visibleAfterDealing.x * 0.4, 0)
      ..priority = 100
      ..anchor = Anchor.center
      ..addToParent(gameRef.world);
  }

  void handle(Event<GameEvent> event) {
    _handStateMachine.handle(event);
  }

  void showCardPlayButton() {
    _cardPlayButton.show();
  }

  void hideCardPlayButton() {
    _cardPlayButton.hide();
  }

  void _setupStateMachine() {
    _handStateMachine.setup({
      HandState.initial: {
        GameEvent.tapPickUpRegion: EventAction(
          (event) => pickUpCards(facingDownCardsByTopMost: event.payload),
          HandState.pickingUp,
        ),
      },
      HandState.pickingUp: {
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
          (event) {
            moveSelectedCardToPreviewingPosition(selectedCardId: event.payload);
            showCardPlayButton();
          },
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
          (event) => _transformTapCardFrontEvent(event as Event<GameEvent>),
          HandState.previewing,
        ),
        GameEvent.tapCardInHand: EventAction(
          (event) => swapPreviewingCard(selectedCardId: event.payload),
          HandState.previewing,
        ),
        GameEvent.tapPreviewingCard: EventAction(
          (event) {
            movePreviewingCardBackToHand();
            hideCardPlayButton();
          },
          HandState.handUp,
        ),
        GameEvent.playCard: EventAction(
          (event) {
            playPreviewingCard();
          },
          HandState.handUp,
        ),
      }
    });
  }

  void _transformTapCardFrontEvent(Event<GameEvent> event) {
    final transformedEvent = Event(
      _previewingCardId == event.payload
          ? GameEvent.tapPreviewingCard
          : GameEvent.tapCardInHand,
      event.payload,
    );
    _handStateMachine.handle(transformedEvent);
  }
}

enum HandState { initial, pickingUp, handUp, handDown, previewing }
