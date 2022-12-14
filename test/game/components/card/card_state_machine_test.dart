import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

import '../../../utils.dart';

class _MockCardStateMachine extends CardStateMachine {
  CardState mockState = CardState.inDeck;
  bool turnMockStateOff = false;

  @override
  CardState get state => turnMockStateOff ? super.state : mockState;
}

class _MockGame extends FlameGame
    with HasTappableComponents, HasHoverableComponents {}

class _MockGameMap extends GameMap {
  bool mockIsMyPosition = false;

  @override
  bool isMyPosition(Vector2 position) => mockIsMyPosition;
}

void main() {
  group('CardStateMachine', () {
    late _MockCardStateMachine machine;
    late MockSingleEventSubscriber subscriber;

    setUp(() async {
      await loadTestAssets();
      machine = _MockCardStateMachine();
      subscriber = MockSingleEventSubscriber();
      machine.addSubscriber(subscriber);
    });

    test('is $Subscriber', () {
      expect(machine, isA<Subscriber>());
    });

    test('is $PositionComponent', () {
      expect(machine, isA<PositionComponent>());
    });

    test('is $HoverCallbacks', () {
      expect(machine, isA<HoverCallbacks>());
    });

    test('is $Publisher', () {
      expect(machine, isA<Publisher>());
    });

    test('handCursor', () {
      machine.turnMockStateOff = true;

      machine.changeState(CardState.inDeck);
      expect(machine.handCursor, false);

      machine.changeState(CardState.inDealRegion);
      expect(machine.handCursor, false);

      machine.changeState(CardState.inMyDealRegion);
      expect(machine.handCursor, true);

      machine.changeState(CardState.inHand);
      expect(machine.handCursor, true);
    });

    group('at ${CardState.inDeck}', () {
      setUp(() {
        machine.mockState = CardState.inDeck;
      });

      group('on ${CardEvent.deal}', () {
        test('given payload.cardIndex not equal parent cardIndex, do nothing',
            () {
          final payload = CardDealPayload(0, Vector2.zero());
          machine.parent = Card(cardIndex: 1);

          machine.onNewEvent(Event(CardEvent.deal)..payload = payload);

          machine.turnMockStateOff = true;
          expect(machine.state, CardState.inDeck);
          expect(subscriber.receivedEvent, null);
        });

        group('given payload.cardIndex equal parent cardIndex', () {
          test(
              'not isMyDealRegion, change to ${CardState.inAnimation}, notify ${CardStateMachineEvent.toDealRegion}',
              () {
            MainGame.gameMap = _MockGameMap()..mockIsMyPosition = false;
            final payload = CardDealPayload(1, Vector2.zero());
            machine.parent = Card(cardIndex: 1);

            machine.onNewEvent(Event(CardEvent.deal)..payload = payload);

            machine.turnMockStateOff = true;
            expect(machine.state, CardState.inAnimation);
            expect(
                subscriber.receivedEvent,
                Event(CardStateMachineEvent.toDealRegion)
                  ..payload = payload
                  ..reverseEvent = CardStateMachineEvent.animationCompleted
                  ..reversePayload = CardState.inDealRegion);
          });

          test(
              'isMyDealRegion, change to ${CardState.inAnimation}, notify ${CardStateMachineEvent.toDealRegion}',
              () {
            MainGame.gameMap = _MockGameMap()..mockIsMyPosition = true;
            final payload = CardDealPayload(1, Vector2.zero());
            machine.parent = Card(cardIndex: 1);

            machine.onNewEvent(Event(CardEvent.deal)..payload = payload);

            machine.turnMockStateOff = true;
            expect(machine.state, CardState.inAnimation);
            expect(
                subscriber.receivedEvent,
                Event(CardStateMachineEvent.toDealRegion)
                  ..payload = payload
                  ..reverseEvent = CardStateMachineEvent.animationCompleted
                  ..reversePayload = CardState.inMyDealRegion);
          });
        });
      });
    });

    group('at ${CardState.inHand}', () {
      test(
        'on ${HandToggleButtonEvent.tapHide}, notify ${CardStateMachineEvent.pullDown}',
        () {
          machine.mockState = CardState.inHand;

          machine.onNewEvent(Event(HandToggleButtonEvent.tapHide));

          machine.turnMockStateOff = true;
          expect(
              subscriber.receivedEvent, Event(CardStateMachineEvent.pullDown));
          expect(machine.state, CardState.inHandCollapsed);
        },
      );

      test(
        'on ${PlaceCardButtonEvent.tap}, notify ${CardStateMachineEvent.pullDown}',
        () {
          machine.mockState = CardState.inHand;

          machine.onNewEvent(Event(PlaceCardButtonEvent.tap));

          machine.turnMockStateOff = true;
          expect(
              subscriber.receivedEvent, Event(CardStateMachineEvent.pullDown));
          expect(machine.state, CardState.inHandCollapsed);
        },
      );

      testWithGame<_MockGame>(
        'on tap, notify ${CardStateMachineEvent.tapWhileInHand}',
        _MockGame.new,
        (game) async {
          machine.mockState = CardState.inHand;
          final p = Card();
          p.add(machine);
          await game.ensureAdd(p);

          machine.onTapDown(createTapDownEvents());

          expect(
            subscriber.receivedEvent,
            Event(CardStateMachineEvent.tapWhileInHand)
              ..payload = CardIndexPayload(0),
          );
        },
      );

      testWithGame<_MockGame>(
        'on ${CardEvent.preview}, given unmatched cardIndex, do nothing',
        _MockGame.new,
        (game) async {
          const cardIndex = 1;
          machine.mockState = CardState.inHand;
          final p = Card();
          p.add(machine);
          await game.ensureAdd(p);

          machine.onNewEvent(
            Event(CardEvent.preview)..payload = CardIndexPayload(cardIndex),
          );

          expect(subscriber.receivedEvent, null);
        },
      );
    });

    group('at ${CardState.inHandCollapsed}', () {
      test(
        'on ${HandToggleButtonEvent.tapHide}, notify ${CardStateMachineEvent.pullUp}',
        () {
          machine.mockState = CardState.inHandCollapsed;

          machine.onNewEvent(Event(HandToggleButtonEvent.tapShow));

          machine.turnMockStateOff = true;
          expect(subscriber.receivedEvent, Event(CardStateMachineEvent.pullUp));
          expect(machine.state, CardState.inHand);
        },
      );
    });

    group('at ${CardState.inPreviewing}', () {
      testWithGame<_MockGame>(
        'on tap, notify ${CardStateMachineEvent.tapWhileInPreviewing}',
        _MockGame.new,
        (game) async {
          machine.mockState = CardState.inPreviewing;
          final p = Card();
          p.add(machine);
          await game.ensureAdd(p);

          machine.onTapDown(createTapDownEvents());

          expect(
            subscriber.receivedEvent,
            Event(CardStateMachineEvent.tapWhileInPreviewing)
              ..payload = CardIndexPayload(0),
          );
        },
      );

      testWithGame<_MockGame>(
        'on ${CardEvent.previewRevert}, given unmatched cardIndex, do nothing',
        _MockGame.new,
        (game) async {
          const cardIndex = 1;
          machine.mockState = CardState.inPreviewing;
          final p = Card();
          p.add(machine);
          await game.ensureAdd(p);

          machine.onNewEvent(
            Event(CardEvent.previewRevert)
              ..payload = CardIndexPayload(cardIndex),
          );

          expect(subscriber.receivedEvent, null);
        },
      );

      testWithGame<_MockGame>(
        'on ${CardEvent.previewSwap}, giving matched cardIndex, notify ${CardStateMachineEvent.swapBackToHand}',
        _MockGame.new,
        (game) async {
          const cardIndex = 1;
          machine.mockState = CardState.inPreviewing;
          final p = Card(cardIndex: cardIndex);
          p.add(machine);
          await game.ensureAdd(p);

          machine.onNewEvent(
            Event(CardEvent.previewSwap)..payload = CardIndexPayload(cardIndex),
          );

          expect(subscriber.receivedEvent,
              Event(CardStateMachineEvent.swapBackToHand));
        },
      );

      testWithGame<_MockGame>(
        'on ${PlaceCardButtonEvent.tap}, change state to OnTable, notify ToTable',
        _MockGame.new,
        (game) async {
          machine.mockState = CardState.inPreviewing;
          final p = Card();
          p.add(machine);
          await game.ensureAdd(p);

          machine.onNewEvent(Event(PlaceCardButtonEvent.tap));

          machine.turnMockStateOff = true;
          expect(machine.state, CardState.onTable);
          expect(
              subscriber.receivedEvent, Event(CardStateMachineEvent.toTable));
        },
      );
    });
  });
}
