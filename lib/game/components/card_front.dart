import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/painting.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/state_machine/state_machine.dart';

enum CardPlace {
  inHand,
  onTheTable,
}

class CardFront extends SpriteComponent
    with HoverCallbacks, TapCallbacks, HasGameRef<BaseGame> {
  CardFront({
    required this.id,
  });

  final int id;
  CardPlace cardPlace = CardPlace.inHand;

  @override
  Future<void>? onLoad() async {
    sprite = gameAssets.cardSprites[id];
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.children
        .query<Player>()
        .firstOrNull
        ?.handle(Event(GameEvent.tapCardFront, id));
  }

  @override
  void onHoverEnter(int hoverId) {
    super.onHoverEnter(hoverId);
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

  static List<CardFront> findCardsInHand(BaseGame game) => game.world.children
      .query<CardFront>()
      .where((c) => c.cardPlace == CardPlace.inHand)
      .toList();
  static CardFront findById(BaseGame game, int id) =>
      game.world.children.query<CardFront>().firstWhere((e) => e.id == id);

  PositionComponent? _inHandPlaceholder;
  void moveToPreviewingPosition() {
    _inHandPlaceholder = PositionComponent(
      size: size,
      angle: angle,
      position: position,
    );
    addAll([
      MoveEffect.to(
          GamePosition.previewCard.position, LinearEffectController(0.1)),
      RotateEffect.to(0, LinearEffectController(0.1)),
      ScaleEffect.by(Vector2.all(1.6), LinearEffectController(0.1)),
    ]);
  }

  void moveBackToHand() {
    addAll([
      MoveEffect.to(_inHandPlaceholder!.position, LinearEffectController(0.1)),
      RotateEffect.to(_inHandPlaceholder!.angle, LinearEffectController(0.1)),
      ScaleEffect.to(Vector2.all(1), LinearEffectController(0.1)),
    ]);
  }

  void changePlace(CardPlace place) {
    cardPlace = place;
  }
}

enum CardFrontEvent {
  tapped,
}
