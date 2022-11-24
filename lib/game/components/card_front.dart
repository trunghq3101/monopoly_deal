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

  static List<CardFront> findAll(BaseGame game) =>
      game.world.children.query<CardFront>();
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
}

enum CardFrontEvent {
  tapped,
}

class CardFrontBroadcaster extends ChangeNotifier {
  int? selectedCardId;
  CardFrontEvent? event;

  void onTapDown(int id) {
    event = CardFrontEvent.tapped;
    selectedCardId = id;
    notifyListeners();
  }
}
