import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class _MockGameMap extends GameMap {
  final Vector2 Function(int index) mockInDeckPosition;

  _MockGameMap({required this.mockInDeckPosition});

  @override
  Vector2 inDeckPosition(int index) => mockInDeckPosition(index);
}

void main() {
  group('AddToDeckBehavior', () {
    late AddToDeckBehavior behavior;

    setUp(() {
      behavior = AddToDeckBehavior();
    });

    test('is a Component', () {
      expect(behavior, isA<Component>());
    });

    testWithFlameGame(
      'parent is a PositionComponent',
      (game) async {
        expect(behavior, isA<ParentIsA<PositionComponent>>());
      },
    );

    test('is a subscriber of CardDeckEvent', () {
      expect(behavior, isA<Subscriber<CardDeckEvent>>());
    });

    group('onNewEvent', () {
      group('showUp', () {
        testWithFlameGame(
          'parent is positioned at deckBottomRight',
          (game) async {
            final p = PositionComponent();
            behavior.addToParent(p);
            final deckBottomRight = Vector2.all(100);
            MainGame2.gameMap = GameMap(deckBottomRight: deckBottomRight);
            await game.ensureAdd(p);

            behavior.onNewEvent(CardDeckEvent.showUp);
            await game.ready();

            expect(p.position, deckBottomRight);
          },
        );

        testWithFlameGame(
          'parent has behaviorPriority',
          (game) async {
            final p = PositionComponent();
            const behaviorPriority = 3;
            behavior = AddToDeckBehavior(priority: behaviorPriority);
            behavior.addToParent(p);
            await game.ensureAdd(p);

            behavior.onNewEvent(CardDeckEvent.showUp);
            await game.ready();

            expect(p.priority, behaviorPriority);
          },
        );

        testWithFlameGame(
          'parent is moved to inDeckPosition after 0.6s',
          (game) async {
            final p = PositionComponent();
            const behaviorIndex = 4;
            behavior = AddToDeckBehavior(index: behaviorIndex);
            behavior.addToParent(p);
            final inDeckPosition = Vector2.all(100);
            MainGame2.gameMap = _MockGameMap(
              mockInDeckPosition: (index) =>
                  index == behaviorIndex ? inDeckPosition : Vector2.zero(),
            );
            await game.ensureAdd(p);

            behavior.onNewEvent(CardDeckEvent.showUp);
            await game.ready();
            game.update(0.6);

            expect(p.position, inDeckPosition);
          },
        );

        testWithFlameGame(
          'is removed from parent once finished after 0.6s',
          (game) async {
            final p = PositionComponent();
            behavior.addToParent(p);
            await game.ensureAdd(p);

            behavior.onNewEvent(CardDeckEvent.showUp);
            await game.ready();
            game.update(0.6);
            await game.ready();

            expect(p.children.query<AddToDeckBehavior>(), isEmpty);
          },
        );
      });
    });
  });
}
