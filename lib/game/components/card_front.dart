import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:monopoly_deal/game/game.dart';

class CardFront extends SpriteComponent with HoverCallbacks {
  CardFront({required this.id});

  final int id;

  @override
  Future<void>? onLoad() async {
    sprite = gameAssets.cardSprites[id];
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
}
