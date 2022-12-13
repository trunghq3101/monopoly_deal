import 'package:flame/components.dart';
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

class _MockSubscriber implements Subscriber<CardStateMachineEvent> {
  CardStateMachineEvent? receivedEvent;
  Object? receivedPayload;

  @override
  void onNewEvent(CardStateMachineEvent event, [Object? payload]) {
    receivedEvent = event;
    receivedPayload = payload;
  }
}

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

    test('is ${Subscriber<CardEvent>}', () {
      expect(machine, isA<Subscriber<CardEvent>>());
    });

    test('is $PositionComponent', () {
      expect(machine, isA<PositionComponent>());
    });

    test('is $HoverCallbacks', () {
      expect(machine, isA<HoverCallbacks>());
    });

    test('is ${Publisher<CardStateMachineEvent>}', () {
      expect(machine, isA<Publisher<CardStateMachineEvent>>());
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

    group('at ${CardState.inMyDealRegion}', () {
      test('onHoverEnter, ', () {});
    });
  });
}
