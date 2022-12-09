import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

void main() {
  group('TogglePreviewingBehavior', () {
    late TogglePreviewingBehavior behavior;

    setUp(() {
      behavior = TogglePreviewingBehavior();
    });

    test('is subscriber of CardStateMachineEvent', () {
      expect(behavior, isA<Subscriber<CardStateMachineEvent>>());
    });

    testWithFlameGame(
      'parent is a PositionComponent',
      (game) async {
        expect(behavior, isA<ParentIsA<PositionComponent>>());
      },
    );

    group('onNewEvent', () {
      testWithFlameGame(
        'toPreviewing, parent has effects added',
        (game) async {
          final mockParent = PositionComponent();
          behavior.addToParent(mockParent);
          await game.ensureAdd(mockParent);

          behavior.onNewEvent(CardStateMachineEvent.toPreviewing);
          await game.ready();

          expect(mockParent.children.query<MoveEffect>(), isNotEmpty);
          expect(mockParent.children.query<RotateEffect>(), isNotEmpty);
          expect(mockParent.children.query<ScaleEffect>(), isNotEmpty);
        },
      );

      testWithFlameGame(
        'toHand, without toPreviewing before, do nothing',
        (game) async {
          final mockParent = PositionComponent();
          behavior.addToParent(mockParent);
          await game.ensureAdd(mockParent);

          behavior.onNewEvent(CardStateMachineEvent.toHand);
          await game.ready();

          expect(mockParent.children.query<MoveEffect>(), isEmpty);
          expect(mockParent.children.query<RotateEffect>(), isEmpty);
          expect(mockParent.children.query<ScaleEffect>(), isEmpty);
        },
      );

      testWithFlameGame(
        'toPreviewing, then toHand, parent back to original position and angle',
        (game) async {
          final originalPosition = Vector2.all(200);
          const originalAngle = 0.5;
          final mockParent = PositionComponent(
            position: originalPosition,
            angle: originalAngle,
          );
          behavior.addToParent(mockParent);
          await game.ensureAdd(mockParent);

          behavior.onNewEvent(CardStateMachineEvent.toPreviewing);
          await game.ready();
          game.update(5);

          expect(mockParent.position, isNot(originalPosition));
          expect(mockParent.angle, isNot(originalAngle));

          behavior.onNewEvent(CardStateMachineEvent.toHand);
          await game.ready();
          game.update(5);

          expect(mockParent.position, originalPosition);
          expect(mockParent.angle, originalAngle);
          expect(mockParent.scale, Vector2.all(1));
        },
      );
    });
  });
}
