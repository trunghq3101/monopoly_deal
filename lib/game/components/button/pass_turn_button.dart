import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class PassTurnButton extends PositionComponent
    with
        TapCallbacks,
        Publisher,
        Subscriber,
        HasGameReference<FlameGame>,
        HasGamePage {
  PassTurnButton({CardTracker? cardTracker})
      : _cardTracker = cardTracker ?? CardTracker();

  late final CardTracker _cardTracker;
  PassTurnButtonState _state = PassTurnButtonState.invisible;

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.bottomLeft;
    size = MainGame.gameMap.buttonSize;
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_cardTracker.myCards().length > 7) {
      final cardInPreviewing = _cardTracker.cardInPreviewingState();
      if (cardInPreviewing != null) {
        notify(Event(CardEvent.previewRevert)
          ..payload = CardIndexPayload(cardInPreviewing.cardIndex));
      }
      add(TimerComponent(
        period: 0.1,
        removeOnFinish: true,
        onTick: () {
          for (var c in _cardTracker.cardsInHandFromTop()) {
            notify(Event(CardEvent.discarding)
              ..payload = CardIndexPayload(c.cardIndex));
          }
        },
      ));
      world.add(DiscardArea(cardTracker: _cardTracker));
      return;
    }
    gameMaster.roomGateway.endTurn();
  }

  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.pickUpToHand:
        final roomGateway = gameMaster.roomGateway;
        if (roomGateway.isMyTurn == true) {
          if (_state == PassTurnButtonState.invisible) {
            _state = PassTurnButtonState.visible;
            add(TimerComponent(
                period: 0.8,
                removeOnFinish: true,
                onTick: () {
                  add(ButtonComponent(text: "END", textAlign: TextAlign.left));
                }));
          }
        }
        break;
      case PacketType.turnPassed:
        final roomGateway = gameMaster.roomGateway;
        if (roomGateway.isMyTurn == true) {
          if (_state == PassTurnButtonState.invisible) {
            _state = PassTurnButtonState.visible;
            add(ButtonComponent(text: "END", textAlign: TextAlign.left));
          }
        } else {
          _state = PassTurnButtonState.invisible;
          children.query<ButtonComponent>().firstOrNull?.removeFromParent();
        }

        break;
      default:
    }
  }
}

enum PassTurnButtonState { visible, invisible }
