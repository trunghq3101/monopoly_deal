import 'dart:async';

import 'package:flame/components.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class GameMaster extends Component with Subscriber {
  GameMaster(this.roomGateway);

  final RoomGateway roomGateway;
  int remainingInTurn = 3;
  final List<StreamSubscription<WsDto>> _gameEventsSubscriptions = [];
  int? _remainingToDeal;

  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardDeckEvent.dealing:
        final payload = (event.payload as CardDeckDealingPayload);
        _remainingToDeal = payload.amount;
        if (!payload.isDealStartGame) {
          _pauseGameEvents();
        }
        break;
      case CardEvent.cardDealt:
        if (_remainingToDeal == null) return;
        _remainingToDeal = _remainingToDeal! - 1;
        if (_remainingToDeal == 0) {
          _remainingToDeal = null;
          _resumeGameEvents();
        }
        break;
      default:
    }
  }

  void play(int cardIndex) {
    roomGateway.sendCardEvent(PacketType.playCard, cardIndex);
    remainingInTurn--;
  }

  void discard(int cardIndex) {
    roomGateway.sendCardEvent(PacketType.discard, cardIndex);
  }

  bool get isPlayable => remainingInTurn > 0;

  void takeTurn() {
    remainingInTurn = 3;
  }

  void addGameEventSubscription(StreamSubscription<WsDto> sub) {
    _gameEventsSubscriptions.add(sub);
  }

  void _pauseGameEvents() {
    for (var s in _gameEventsSubscriptions) {
      s.pause();
    }
  }

  void _resumeGameEvents() {
    for (var s in _gameEventsSubscriptions) {
      s.resume();
    }
  }
}
