import 'package:equatable/equatable.dart';
import 'package:flame/game.dart';

enum CardStateMachineEvent {
  animationCompleted,
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
  toTable,
}

enum CardDeckEvent { showUp, dealStartGame, dealing, pickUp }

enum CardEvent {
  addedToDeck,
  deal,
  cardDealt,
  pickUp,
  pickUpForOpponent,
  preview,
  previewRevert,
  previewSwap,
  reposition,
  cardRevealed,
  zoomCardsOut,
}

class CardDealPayload with EquatableMixin {
  final int cardIndex;
  final Vector2 playerPosition;
  final int orderIndex;

  CardDealPayload(this.cardIndex, this.playerPosition, {this.orderIndex = 0});

  @override
  List<Object?> get props => [cardIndex, playerPosition, orderIndex];
}

class CardPickUpPayload with EquatableMixin {
  final int cardIndex;
  final int orderIndex;
  final InHandPosition inHandPosition;

  CardPickUpPayload(
    this.cardIndex, {
    this.orderIndex = 0,
    InHandPosition? inHandPosition,
  }) : inHandPosition = inHandPosition ?? InHandPosition.test();

  @override
  List<Object?> get props => [cardIndex, orderIndex, inHandPosition];
}

class CardRepositionPayload with EquatableMixin {
  final int cardIndex;
  final InHandPosition inHandPosition;

  CardRepositionPayload(this.cardIndex, {InHandPosition? inHandPosition})
      : inHandPosition = inHandPosition ?? InHandPosition.test();

  @override
  List<Object?> get props => [cardIndex, inHandPosition];
}

class InHandPosition with EquatableMixin {
  InHandPosition(this.position, this.angle);

  final Vector2 position;
  final double angle;

  factory InHandPosition.test() => InHandPosition(Vector2.zero(), 0);

  @override
  List<Object?> get props => [position, angle];
}

class CardIndexPayload with EquatableMixin {
  final int cardIndex;

  CardIndexPayload(this.cardIndex);

  @override
  List<Object?> get props => [cardIndex];
}

class CardDeckDealingPayload with EquatableMixin {
  final int amount;
  final bool isDealStartGame;

  CardDeckDealingPayload({required this.amount, this.isDealStartGame = false});

  @override
  List<Object?> get props => [amount, isDealStartGame];
}
