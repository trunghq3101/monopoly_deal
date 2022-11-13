import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

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

enum CardFrontState {
  initial,
  targeted,
  selected,
}

class CardFront extends SpriteComponent with HasStateMachine {
  CardFront({
    required this.id,
    super.sprite,
    super.position,
    super.size,
    super.anchor = Anchor.center,
  });

  static const kMouseHover = 0;
  static const kMouseHoverLeft = 1;
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
            CardFrontUntargetTransition(CardFrontState.initial, this)
      },
      CardFrontState.selected: {},
    });
  }

  @override
  void render(Canvas canvas) {
    final drawPosition = size / 2;
    final drawSize = size + Vector2.all(15);
    final delta = Anchor.center.toVector2()..multiply(drawSize);

    final rRect = RRect.fromRectAndRadius(
        (drawPosition - delta).toPositionedRect(drawSize),
        const Radius.circular(24));

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
          const Radius.circular(28));
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
