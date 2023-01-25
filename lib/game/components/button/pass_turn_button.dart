import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class PassTurnButton extends PositionComponent
    with Publisher, Subscriber, HasGameReference<FlameGame>, HasGamePage {
  PassTurnButton({CardTracker? cardTracker})
      : _cardTracker = cardTracker ?? CardTracker();

  late final CardTracker _cardTracker;
  PassTurnButtonState _state = PassTurnButtonState.invisible;

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.bottomLeft;
    size = MainGame.gameMap.buttonSize;
  }

  void _onTapDown(TapDownEvent event) {
    if (_cardTracker.myCards().length > 7) {
      final cardInPreviewing = _cardTracker.cardInPreviewingState();
      if (cardInPreviewing != null) {
        notify(Event(CardStateMachineEvent.tapWhileInPreviewing)
          ..payload = CardIndexPayload(cardInPreviewing.cardIndex));
      }
      add(TimerComponent(
        period: 0.2,
        removeOnFinish: true,
        onTick: () {
          for (var c in _cardTracker.cardsInHandFromTop()) {
            notify(Event(CardEvent.discarding)
              ..payload = CardIndexPayload(c.cardIndex));
          }
        },
      ));
      notify(Event(PassTurnButtonEvent.needDiscard));
      _changeState(PassTurnButtonState.invisible);
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
                _changeState(PassTurnButtonState.visible);
              },
            ));
          }
        }
        break;
      case PacketType.turnPassed:
        final roomGateway = gameMaster.roomGateway;
        if (roomGateway.isMyTurn == true) {
          if (_state == PassTurnButtonState.invisible) {
            _changeState(PassTurnButtonState.visible);
          }
        } else {
          _changeState(PassTurnButtonState.invisible);
        }
        break;
      case DiscardAreaEvent.cancel:
        _changeState(PassTurnButtonState.visible);
        break;
      default:
    }
  }

  void _changeState(PassTurnButtonState state) {
    _state = state;
    if (state == PassTurnButtonState.invisible) {
      children.query<ButtonComponent>().firstOrNull?.removeFromParent();
    } else {
      add(ButtonComponent(
        text: "END",
        textAlign: TextAlign.left,
        tapDown: _onTapDown,
      ));
    }
  }
}

enum PassTurnButtonState { visible, invisible }
