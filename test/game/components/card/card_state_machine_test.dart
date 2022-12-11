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

    test('is ${PublisherComponent<CardStateMachineEvent>}', () {
      expect(machine, isA<PublisherComponent<CardStateMachineEvent>>());
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

        test(
            'given payload.cardId equal parent cardId, notify ${CardStateMachineEvent.toDealRegion}',
            () {
          final payload = CardEventDealPayload(1, Vector2.zero());
          machine.parent = Card(cardId: 1);

          machine.onNewEvent(CardEvent.deal, payload);

          machine.turnMockStateOff = true;
          expect(machine.state, CardState.inDealRegion);
          expect(subscriber.receivedEvent, CardStateMachineEvent.toDealRegion);
          expect(subscriber.receivedPayload, payload);
        });
      });
    });
  });
}
