import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/animation.dart';

class Command {
  final int id;

  Command(this.id);

  @override
  bool operator ==(Object other) => other is Command && other.id == id;

  @override
  int get hashCode => id;
}

class State {
  final Map<Command, Transition> _transitions = {};

  void addTransition(MapEntry<Command, Transition> transition) {
    _transitions.addEntries([transition]);
  }

  State handle(Command command) {
    return _transitions.entries
            .firstWhereOrNull((e) => e.key == command)
            ?.value
            .activate() ??
        this;
  }
}

abstract class Transition {
  State activate();
}

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

  void collapse() {
    _handContent.onCommand(Command(kTapOutsideHand));
  }

  void expand() {
    _handContent.onCommand(Command(kTapInsideHand));
  }
}

class ExpandTransition extends Transition {
  final HandContent hand;

  ExpandTransition(this.hand);

  @override
  State activate() {
    hand.expand();
    return HandContent.expandedState;
  }
}

class CollapseTransition extends Transition {
  final HandContent hand;

  CollapseTransition(this.hand);

  @override
  State activate() {
    hand.collapse();
    return HandContent.collapsedState;
  }
}

const kTapOutsideHand = 0;
const kTapInsideHand = 1;

class HandContent extends PositionComponent with ParentIsA<Hand>, TapCallbacks {
  HandContent() : super(anchor: Anchor.bottomCenter);

  static final collapsedState = State();
  static final expandedState = State();

  late State _state = expandedState;

  @override
  Future<void> onLoad() async {
    size = parent.size;
    position = Vector2(parent.size.x / 2, parent.size.y);
    collapsedState.addTransition(
        MapEntry(Command(kTapInsideHand), ExpandTransition(this)));
    expandedState.addTransition(
        MapEntry(Command(kTapOutsideHand), CollapseTransition(this)));
  }

  @override
  void onTapDown(TapDownEvent event) {
    onCommand(Command(kTapInsideHand));
  }

  void onCommand(Command command) {
    _state = _state.handle(command);
  }

  void collapse() {
    add(MoveEffect.to(
      Vector2(
        position.x,
        parent.size.y + size.y - 100,
      ),
      EffectController(speed: 2000, curve: Curves.easeOut),
    ));
  }

  void expand() {
    add(MoveEffect.to(
      Vector2(parent.size.x / 2, parent.size.y),
      EffectController(speed: 2000, curve: Curves.easeOut),
    ));
  }
}
