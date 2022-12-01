import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/painting.dart';
import 'package:monopoly_deal/game/game.dart';

enum CardPlace {
  inHand,
  onTheTable,
}

class CardFront extends SpriteComponent
    with
        HoverCallbacks,
        TapCallbacks,
        HasGameRef<BaseGame>,
        CardStateCallbacks {
  CardFront({
    required this.id,
  });

  final int id;
  late CardState _state = Idle(this);
  CardPlace cardPlace = CardPlace.inHand;

  @override
  Future<void>? onLoad() async {
    sprite = gameAssets.cardSprites[id];
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }

  @override
  void onHoverEnter(int hoverId) {
    super.onHoverEnter(hoverId);
    if (cardPlace == CardPlace.onTheTable) {
      return;
    }
    decorator.addLast(GlowingDecorator(
      component: this,
      spread: 40,
      radius: const Radius.circular(56),
      color: const Color.fromARGB(255, 147, 252, 241),
      sigma: 10,
    ));
  }

  @override
  void onHoverLeave() {
    super.onHoverLeave();
    decorator.removeLast();
  }

  @override
  void onTap() {
    _state.onTap();
  }

  void pickUp() {
    changeState(InHand(this));
  }

  static List<CardFront> findCardsInHand(BaseGame game) => game.world.children
      .query<CardFront>()
      .where((c) => c.cardPlace == CardPlace.inHand)
      .toList();
  static CardFront findById(BaseGame game, int id) =>
      game.world.children.query<CardFront>().firstWhere((e) => e.id == id);

  PositionComponent? _inHandPlaceholder;

  void changePlace(CardPlace place) {
    cardPlace = place;
  }

  void changeState(CardState state) {
    _state = state;
  }
}

class Idle extends CardState {
  Idle(super.cardFront);
}

class InHand extends CardState {
  InHand(super.cardFront);

  @override
  void onTap() {
    _moveToPreviewingPosition();
    cardFront.changeState(Previewing(cardFront));
  }

  void _moveToPreviewingPosition() {
    cardFront._inHandPlaceholder = PositionComponent(
      size: cardFront.size,
      angle: cardFront.angle,
      position: cardFront.position,
    );
    cardFront.addAll([
      MoveEffect.to(
          GamePosition.previewCard.position, LinearEffectController(0.1)),
      RotateEffect.to(0, LinearEffectController(0.1)),
      ScaleEffect.by(Vector2.all(1.6), LinearEffectController(0.1)),
    ]);
  }
}

class Previewing extends CardState {
  Previewing(super.cardFront);

  @override
  void onTap() {
    _moveBackToHand();
    cardFront.changeState(InHand(cardFront));
  }

  void _moveBackToHand() {
    cardFront.addAll([
      MoveEffect.to(
          cardFront._inHandPlaceholder!.position, LinearEffectController(0.1)),
      RotateEffect.to(
          cardFront._inHandPlaceholder!.angle, LinearEffectController(0.1)),
      ScaleEffect.to(Vector2.all(1), LinearEffectController(0.1)),
    ]);
  }
}

class CardState with CardStateCallbacks {
  CardState(this.cardFront);
  final CardFront cardFront;
}

mixin CardStateCallbacks {
  void onTap() {}
}
