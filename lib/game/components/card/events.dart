import 'package:equatable/equatable.dart';
import 'package:flame/game.dart';

enum CardStateMachineEvent {
  toDealRegion,
  tapOnMyDealRegion,
  pickUpToHand,
  pullUp,
  pullDown,
  tapWhileInHand,
  tapWhileInPreviewing,
  toHand,
  toPreviewing,
  swapBackToHand,
}

enum CardDeckEvent { showUp, dealStartGame }

enum CardEvent {
  addedToDeck,
  deal,
  pickUp,
  preview,
  previewRevert,
  previewSwap
}

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

class CardIdPayload with EquatableMixin {
  final int cardId;

  CardIdPayload(this.cardId);

  @override
  List<Object?> get props => [cardId];
}
