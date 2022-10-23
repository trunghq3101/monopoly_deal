import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game_components/card_front.dart';
import 'package:monopoly_deal/game_components/hand.dart';

import 'card.dart';

class PickUpRegion extends PositionComponent
    with HasGameReference<FlameGame>, TapCallbacks {
  PickUpRegion({
    super.size,
    super.position,
    super.anchor,
  });

  bool _tapped = false;
  Hand get _hand => game.children
      .query<CameraComponent>()
      .first
      .viewport
      .children
      .query<Hand>()
      .first;

  @override
  Future<void>? onLoad() async {
    children.register<Card>();
  }

  @override
  void onMount() {
    super.onMount();
    assert(_hand.isLoaded);
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    if (type == ChildrenChangeType.added && child is Card) {
      final s = _hand.size * 0.6;
      _hand.add(CardFront(
        id: child.id,
        size: s,
        position: Vector2(_hand.position.x, _hand.size.y - s.y / 2 + s.y * 3),
      ));
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_tapped) {
      return;
    }
    _tapped = true;
    final cards = children.query<Card>();
    for (var i = 0; i < cards.length; i++) {
      cards[i].addAll([
        RotateEffect.to(0, LinearEffectController(0.3)),
        SequenceEffect([
          MoveEffect.by(
            Vector2((i + 0.5 - cards.length / 2) * 1600, 0),
            LinearEffectController(0.5),
          ),
          MoveEffect.by(
            Vector2((i + 0.5 - cards.length / 2) * -1600, 4000),
            LinearEffectController(0.5),
          ),
        ]),
      ]);
    }
    var i = 0;
    final r = _hand.size.x - _hand.firstChild<CardFront>()!.size.x / 2;
    final l = _hand.firstChild<CardFront>()!.size.x / 2;
    final d = (r - l) / (_hand.children.query<CardFront>().length - 1);
    for (var c in _hand.children.query<CardFront>()) {
      c.position = Vector2(r - d * i, c.position.y);
      c.add(MoveEffect.by(
        Vector2(0, c.size.y * -3),
        DelayedEffectController(LinearEffectController(0.5),
            delay: 1 + i * 0.2),
      ));
      i++;
    }
  }
}
