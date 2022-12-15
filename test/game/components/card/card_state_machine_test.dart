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

class _MockSubscriber implements Subscriber {
  Object? receivedEvent;
  Object? receivedPayload;

  @override
  void onNewEvent(event, [Object? payload]) {
    receivedEvent = event;
    receivedPayload = payload;
  }
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
    late _MockSubscriber subscriber;

    setUp(() async {
      await loadTestAssets();
      machine = _MockCardStateMachine();
      subscriber = _MockSubscriber();
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
        test('given payload.cardId not equal parent cardId, do nothing', () {
          final payload = CardEventDealPayload(0, Vector2.zero());
          machine.parent = Card(cardId: 1);

          machine.onNewEvent(CardEvent.deal, payload);

          machine.turnMockStateOff = true;
          expect(machine.state, CardState.inDeck);
          expect(subscriber.receivedEvent, null);
        });

        group('given payload.cardId equal parent cardId', () {
          test(
              'not isMyDealRegion, change to ${CardState.inDealRegion}, notify ${CardStateMachineEvent.toDealRegion}',
              () {
            MainGame2.gameMap = _MockGameMap()..mockIsMyPosition = false;
            final payload = CardEventDealPayload(1, Vector2.zero());
            machine.parent = Card(cardId: 1);

            machine.onNewEvent(CardEvent.deal, payload);

            machine.turnMockStateOff = true;
            expect(machine.state, CardState.inDealRegion);
            expect(
                subscriber.receivedEvent, CardStateMachineEvent.toDealRegion);
            expect(subscriber.receivedPayload, payload);
          });

          test(
              'isMyDealRegion, change to ${CardState.inMyDealRegion}, notify ${CardStateMachineEvent.toDealRegion}',
              () {
            MainGame2.gameMap = _MockGameMap()..mockIsMyPosition = true;
            final payload = CardEventDealPayload(1, Vector2.zero());
            machine.parent = Card(cardId: 1);

            machine.onNewEvent(CardEvent.deal, payload);

            machine.turnMockStateOff = true;
            expect(machine.state, CardState.inMyDealRegion);
            expect(
                subscriber.receivedEvent, CardStateMachineEvent.toDealRegion);
            expect(subscriber.receivedPayload, payload);
          });
        });
      });
    });

    group('at ${CardState.inHand}', () {
      test(
        'on ${HandToggleButtonEvent.tapHide}, notify ${CardStateMachineEvent.pullDown}',
        () {
          machine.mockState = CardState.inHand;

          machine.onNewEvent(HandToggleButtonEvent.tapHide);

          machine.turnMockStateOff = true;
          expect(subscriber.receivedEvent, CardStateMachineEvent.pullDown);
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
            CardStateMachineEvent.tapWhileInHand,
          );
        },
      );

      testWithGame<_MockGame>(
        'on ${CardEvent.preview}, given unmatched cardId, do nothing',
        _MockGame.new,
        (game) async {
          const cardId = 1;
          machine.mockState = CardState.inHand;
          final p = Card();
          p.add(machine);
          await game.ensureAdd(p);

          machine.onNewEvent(CardEvent.preview, CardIdPayload(cardId));

          expect(subscriber.receivedEvent, null);
        },
      );
    });

    group('at ${CardState.inHandCollapsed}', () {
      test(
        'on ${HandToggleButtonEvent.tapHide}, notify ${CardStateMachineEvent.pullUp}',
        () {
          machine.mockState = CardState.inHandCollapsed;

          machine.onNewEvent(HandToggleButtonEvent.tapShow);

          machine.turnMockStateOff = true;
          expect(subscriber.receivedEvent, CardStateMachineEvent.pullUp);
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
            CardStateMachineEvent.tapWhileInPreviewing,
          );
        },
      );

      testWithGame<_MockGame>(
        'on ${CardEvent.previewRevert}, given unmatched cardId, do nothing',
        _MockGame.new,
        (game) async {
          const cardId = 1;
          machine.mockState = CardState.inPreviewing;
          final p = Card();
          p.add(machine);
          await game.ensureAdd(p);

          machine.onNewEvent(CardEvent.previewRevert, CardIdPayload(cardId));

          expect(subscriber.receivedEvent, null);
        },
      );

      testWithGame<_MockGame>(
        'on ${CardEvent.previewSwap}, giving matched cardId, notify ${CardStateMachineEvent.swapBackToHand}',
        _MockGame.new,
        (game) async {
          const cardId = 1;
          machine.mockState = CardState.inPreviewing;
          final p = Card(cardId: cardId);
          p.add(machine);
          await game.ensureAdd(p);

          machine.onNewEvent(CardEvent.previewSwap, CardIdPayload(cardId));

          expect(
              subscriber.receivedEvent, CardStateMachineEvent.swapBackToHand);
        },
      );
    });
  });
}
