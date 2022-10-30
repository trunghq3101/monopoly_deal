import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/animation.dart';

class Hand extends PositionComponent with ParentIsA<Viewport> {
  Hand() : super(anchor: Anchor.bottomCenter);

  late final HandContent _handContent;
  Vector2 _originSize = Vector2.zero();
  late Function(Vector2 size) _resizeHandler = _setOriginSize;

  @override
  Future<void> onLoad() async {
    _handContent = HandContent();
    add(_handContent);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(size.x / 2, size.y);
    _resizeHandler(size);
  }

  void _setOriginSize(Vector2 size) {
    this.size = _calcSize(size);
    _originSize = this.size;
    _resizeHandler = _setScale;
  }

  void _setScale(Vector2 size) {
    final newSize = _calcSize(size);
    scale = Vector2.all(newSize.x / _originSize.x);
  }

  Vector2 _calcSize(Vector2 size) => size.x * 3 / 4 < size.y - 20
      ? Vector2(size.x, size.x * 3 / 4)
      : Vector2((size.y - 20) * 4 / 3, size.y - 20)
    ..clamp(Vector2.zero(), Vector2(800, 600));

  void onAction(String action) {
    _handContent.onAction(action);
  }
}

class HandContent extends PositionComponent with ParentIsA<Hand> {
  HandContent() : super(anchor: Anchor.bottomCenter);
  late String _state = 'expand';
  late final _transitions = {
    'collapse': {
      'expand': expand,
    },
    'expand': {'collapse': collapse}
  };

  @override
  Future<void> onLoad() async {
    size = parent.size;
    position = Vector2(parent.size.x / 2, parent.size.y);
  }

  void onAction(String action) {
    _transitions[_state]!
        .entries
        .firstWhereOrNull((e) => e.key == action)
        ?.value();
  }

  void collapse() {
    add(MoveEffect.to(
      Vector2(
        position.x,
        parent.size.y + size.y - 100,
      ),
      EffectController(speed: 2000, curve: Curves.easeOut),
    ));
    _state = 'collapse';
  }

  void expand() {
    add(MoveEffect.to(
      Vector2(parent.size.x / 2, parent.size.y),
      EffectController(speed: 2000, curve: Curves.easeOut),
    ));
    _state = 'expand';
  }
}
