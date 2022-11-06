import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flutter/animation.dart';
import 'package:monopoly_deal/game_components/mixins.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

class ExpandTransition extends Transition {
  final Hand hand;

  ExpandTransition(this.hand);

  @override
  State onActivate() {
    hand.add(MoveEffect.by(
      Vector2(0, -(hand.size.y - 100)),
      EffectController(speed: 2000, curve: Curves.easeOut),
    ));
    return Hand.expandedState;
  }
}

class CollapseTransition extends Transition {
  final Hand hand;

  CollapseTransition(this.hand);

  @override
  State onActivate() {
    hand.add(MoveEffect.by(
      Vector2(0, hand.size.y - 100),
      EffectController(speed: 2000, curve: Curves.easeOut),
    ));
    return Hand.collapsedState;
  }
}

const kTapOutsideHand = 0;
const kTapInsideHand = 1;

class Hand extends HudMarginComponent with TapCallbacks, TapOutsideCallback {
  Hand({super.children})
      : super(
          anchor: Anchor.bottomCenter,
          position: Vector2.zero(),
        );

  static final collapsedState = State(debugName: 'collapsed');
  static final expandedState = State(debugName: 'expanded');

  late State _state = expandedState;

  @override
  Future<void> onLoad() async {
    position = Vector2(gameRef.size.x / 2, gameRef.size.y);
    size = _calcSize(gameRef.size);
    super.onLoad();
    collapsedState.addTransition(
        MapEntry(Command(kTapInsideHand), ExpandTransition(this)));
    expandedState.addTransition(
        MapEntry(Command(kTapOutsideHand), CollapseTransition(this)));
  }

  @override
  void onTapDown(TapDownEvent event) {
    tapOutsideSubscribed = true;
    onCommand(Command(kTapInsideHand));
  }

  @override
  void onTapOutside() {
    tapOutsideSubscribed = false;
    onCommand(Command(kTapOutsideHand));
  }

  void onCommand(Command command) {
    _state = _state.handle(command);
  }

  Vector2 _calcSize(Vector2 size) => size.x * 3 / 4 < size.y - 20
      ? Vector2(size.x, size.x * 3 / 4)
      : Vector2((size.y - 20) * 4 / 3, size.y - 20)
    ..clamp(Vector2.zero(), Vector2(800, 600));
}
