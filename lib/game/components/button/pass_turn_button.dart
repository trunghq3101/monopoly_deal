import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class PassTurnButton extends PositionComponent
    with TapCallbacks, Subscriber, HasGameReference<FlameGame> {
  PassTurnButtonState _state = PassTurnButtonState.invisible;

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.bottomLeft;
    size = Vector2(380, 160);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final gameMaster = game.children.query<GameMaster>().firstOrNull;
    final roomGateway = gameMaster?.roomGateway;
    roomGateway?.endTurn();
  }

  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.pickUpToHand:
        final gameMaster = game.children.query<GameMaster>().firstOrNull;
        final roomGateway = gameMaster?.roomGateway;
        if (roomGateway?.isMyTurn == true) {
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
        final gameMaster = game.children.query<GameMaster>().firstOrNull;
        final roomGateway = gameMaster?.roomGateway;
        if (roomGateway?.isMyTurn == true) {
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
