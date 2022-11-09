import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/animation.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

class PickUpTransition extends Transition {
  final Card card;

  PickUpTransition(this.card);

  @override
  State onActivate(Command command) {
    card.addAll([
      RotateEffect.to(0, LinearEffectController(0.1)),
      MoveEffect.to(
        Vector2(
            0,
            card.game.children
                .query<CameraComponent>()
                .first
                .viewfinder
                .visibleGameSize!
                .y),
        CurvedEffectController(0.3, Curves.easeInCubic),
      )
    ]);
    return Card.pickedUp;
  }
}

class Card extends SpriteComponent with HasGameReference<FlameGame> {
  Card({
    required this.id,
    super.sprite,
    super.position,
    super.priority,
  }) : super(anchor: Anchor.center);

  static const kCardWidth = 280.0;
  static const kCardHeight = 395.0;
  static final kCardSize = Vector2(kCardWidth, kCardHeight);

  static const kPickUp = 0;

  static final dealed = State(debugName: 'dealed');
  static final pickedUp = State(debugName: 'picked up');

  final int id;
  final _stateMachines = [StateMachine()..start(dealed)];

  @override
  Future<void>? onLoad() {
    dealed.addTransition(MapEntry(Command(kPickUp), PickUpTransition(this)));
    return super.onLoad();
  }

  void onCommand(Command command) {
    for (var m in _stateMachines) {
      m.onCommand(command);
    }
  }
}
