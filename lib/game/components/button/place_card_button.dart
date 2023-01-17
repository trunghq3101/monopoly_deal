import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

enum PlaceCardButtonState {
  visible,
  invisible,
}

class PlaceCardButton extends PositionComponent
    with TapCallbacks, Subscriber, Publisher, HasGameReference<FlameGame> {
  PlaceCardButtonState _state = PlaceCardButtonState.invisible;
  PlaceCardButtonState get state => _state;

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.topCenter;
    size = MainGame.gameMap.buttonSize;
  }

  @override
  void onNewEvent(Event event) {
    final gameMaster = game.children.query<GameMaster>().firstOrNull;
    final roomGateway = gameMaster?.roomGateway;
    final cardTracker = game.children.query<CardTracker>().firstOrNull;
    final isMyTurn = roomGateway?.isMyTurn ?? false;
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.toPreviewing:
        if (gameMaster?.isPlayable == true &&
            isMyTurn &&
            state == PlaceCardButtonState.invisible) {
          _changeState(PlaceCardButtonState.visible);
        }
        break;
      case CardStateMachineEvent.toHand:
        if (isMyTurn && state == PlaceCardButtonState.visible) {
          _changeState(PlaceCardButtonState.invisible);
        }
        break;
      case PacketType.turnPassed:
        if (gameMaster?.isPlayable == true &&
            isMyTurn &&
            cardTracker?.cardInPreviewingState() != null) {
          _changeState(PlaceCardButtonState.visible);
        } else {
          _changeState(PlaceCardButtonState.invisible);
        }
        break;
      default:
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (state == PlaceCardButtonState.visible) {
      notify(Event(PlaceCardButtonEvent.tap));
      _changeState(PlaceCardButtonState.invisible);
    }
  }

  void _changeState(PlaceCardButtonState state) {
    _state = state;
    switch (_state) {
      case PlaceCardButtonState.invisible:
        children.query<ButtonComponent>().firstOrNull?.removeFromParent();
        break;
      case PlaceCardButtonState.visible:
        add(ButtonComponent(text: "PLAY", textAlign: TextAlign.center));
        break;
      default:
    }
  }
}
