import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:monopoly_deal/game/game.dart';

class CardFront extends SpriteComponent with HoverCallbacks, TapCallbacks {
  CardFront({
    required this.id,
    required this.broadcaster,
  });

  final int id;
  final CardFrontBroadcaster broadcaster;

  @override
  Future<void>? onLoad() async {
    sprite = gameAssets.cardSprites[id];
  }

  @override
  void onTapDown(TapDownEvent event) {
    broadcaster.onTapDown(id);
    addAll([
      MoveEffect.to(
          GamePosition.previewCard.position, LinearEffectController(0.1)),
      RotateEffect.to(0, LinearEffectController(0.1)),
      ScaleEffect.by(Vector2.all(1.6), LinearEffectController(0.1)),
    ]);
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

enum CardFrontEvent {
  tapped,
}

class CardFrontBroadcaster extends ChangeNotifier {
  int? id;
  CardFrontEvent? event;

  void onTapDown(int id) {
    event = CardFrontEvent.tapped;
    this.id = id;
    notifyListeners();
  }
}
