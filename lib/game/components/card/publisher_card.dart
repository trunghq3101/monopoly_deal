import 'package:equatable/equatable.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class CardPublisher extends PublisherComponent<CardEvent> {}

enum CardEvent { deal, pickUp, tapped }

class CardEventDealPayload with EquatableMixin {
  final int cardId;
  final Vector2 playerPosition;
  final int orderIndex;

  CardEventDealPayload(this.cardId, this.playerPosition, {this.orderIndex = 0});

  @override
  List<Object?> get props => [cardId, playerPosition, orderIndex];
}

class CardEventPickUpPayload with EquatableMixin {
  final int cardId;
  final int orderIndex;
  final InHandPosition inHandPosition;

  CardEventPickUpPayload(
    this.cardId, {
    this.orderIndex = 0,
    InHandPosition? inHandPosition,
  }) : inHandPosition = inHandPosition ?? InHandPosition.test();

  @override
  List<Object?> get props => [cardId, orderIndex];
}

class InHandPosition {
  InHandPosition(this.position, this.angle);

  final Vector2 position;
  final double angle;

  factory InHandPosition.test() => InHandPosition(Vector2.zero(), 0);
}
