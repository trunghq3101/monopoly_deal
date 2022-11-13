import 'dart:async';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

import 'hand.dart';

class CardFrontTargetTransition extends Transition<CardFrontState> {
  CardFrontTargetTransition(super.dest, this.cardFront);

  final CardFront cardFront;

  @override
  FutureOr<void> onActivate(payload) {
    cardFront.targeting = true;
  }
}

class CardFrontUntargetTransition extends Transition<CardFrontState> {
  CardFrontUntargetTransition(super.dest, this.cardFront);

  final CardFront cardFront;

  @override
  FutureOr<void> onActivate(payload) {
    cardFront.targeting = false;
  }
}

class CardFrontSelectTranstion extends Transition<CardFrontState> {
  CardFrontSelectTranstion(super.dest, this.cardFront);

  final CardFront cardFront;

  @override
  FutureOr<void> onActivate(payload) {
    cardFront.targeting = false;
    final dest = (cardFront.game.size -
                (Vector2(0, 1) *
                    (cardFront.game.children
                            .query<Hand>()
                            .firstOrNull
                            ?.height ??
                        0))) /
            2 -
        (cardFront.parent as CircleComponent).absoluteTopLeftPosition -
        Vector2(0, 0.5) * cardFront.height;
    cardFront.addAll([
      MoveEffect.to(dest, LinearEffectController(0.2)),
      ScaleEffect.by(Vector2.all(1.2), LinearEffectController(0.2))
    ]);
  }
}

enum CardFrontState {
  initial,
  targeted,
  selected,
}

class CardFront extends SpriteComponent
    with HasStateMachine, TapCallbacks, HasGameReference<FlameGame> {
  CardFront({
    required this.id,
    super.sprite,
    super.position,
    super.size,
    super.anchor,
  });

  static const kMouseHover = 0;
  static const kMouseHoverLeft = 1;
  static const kTapDown = 2;
  final int id;
  bool targeting = false;

  @override
  operator ==(other) => other is CardFront && other.id == id;

  @override
  int get hashCode => id;

  @override
  Future<void>? onLoad() async {
    newMachine({
      CardFrontState.initial: {
        Command(kMouseHover):
            CardFrontTargetTransition(CardFrontState.targeted, this)
      },
      CardFrontState.targeted: {
        Command(kMouseHoverLeft):
            CardFrontUntargetTransition(CardFrontState.initial, this),
        Command(kTapDown):
            CardFrontSelectTranstion(CardFrontState.selected, this)
      },
      CardFrontState.selected: {},
    });
  }

  @override
  void onTapDown(TapDownEvent event) {
    onCommand(Command(kTapDown));
  }

  @override
  void render(Canvas canvas) {
    final drawPosition = size / 2;
    final drawSize = size + Vector2.all(15);
    final delta = Anchor.center.toVector2()..multiply(drawSize);

    final rRect = RRect.fromRectAndRadius(
        (drawPosition - delta).toPositionedRect(drawSize),
        const Radius.circular(16));

    canvas.drawRRect(
        rRect,
        Paint()
          ..color = const Color.fromARGB(146, 0, 0, 0)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));

    if (targeting) {
      final targetingSize = drawSize + Vector2.all(15);
      final targetingDelta = Anchor.center.toVector2()..multiply(targetingSize);
      final targetingRect = RRect.fromRectAndRadius(
          (drawPosition - targetingDelta).toPositionedRect(targetingSize),
          const Radius.circular(18));
      canvas.drawRRect(
          targetingRect,
          Paint()
            ..color = const Color.fromARGB(255, 110, 240, 255)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
    }

    canvas.drawRRect(rRect, Paint()..color = const Color(0xFFFFFFFF));
    super.render(canvas);
  }
}
