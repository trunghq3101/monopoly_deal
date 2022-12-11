import 'package:equatable/equatable.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class CardPublisher extends PublisherComponent<CardEvent> {}

enum CardEvent { deal, tapped }

class CardEventDealPayload with EquatableMixin {
  final int cardId;
  final Vector2 playerPosition;
  final int orderIndex;

  CardEventDealPayload(this.cardId, this.playerPosition, {this.orderIndex = 0});

  @override
  List<Object?> get props => [cardId, playerPosition, orderIndex];
}
