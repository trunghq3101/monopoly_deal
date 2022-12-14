import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class _MockSubscriber with Subscriber<CardEvent> {
  final List<CardEvent> receivedEvents = [];
  final List<CardEventPickUpPayload?> receivedPayloads = [];

  @override
  void onNewEvent(CardEvent event, [Object? payload]) {
    receivedEvents.add(event);
    receivedPayloads.add(payload as CardEventPickUpPayload?);
  }
}

class _MockCardTracker extends CardTracker {
  List<HasCardId> mockCardsInMyDealRegion = [];
  @override
  List<HasCardId> cardsInMyDealRegionFromTop() => mockCardsInMyDealRegion;
}

class _MockHasCardId implements HasCardId {
  _MockHasCardId(this._cardId);

  final int _cardId;

  @override
  int get cardId => _cardId;
}

void main() {
  group('$SelectToPickUp', () {
    late SelectToPickUp selector;
    late _MockCardTracker cardTracker;

    setUp(() {
      cardTracker = _MockCardTracker();
      selector = SelectToPickUp(cardTracker: cardTracker);
    });

    test('is ${Subscriber<CardStateMachineEvent>}', () {
      expect(selector, isA<Subscriber<CardStateMachineEvent>>());
    });

    test('is ${Publisher<CardEvent>}', () {
      expect(selector, isA<Publisher<CardEvent>>());
    });

    group('on ${CardStateMachineEvent.tapOnMyDealRegion}', () {
      test('notify ${CardEvent.pickUp} with cardId and orderIndex', () {
        final s = _MockSubscriber();
        selector.addSubscriber(s);
        final cardsInMyDealRegion = <HasCardId>[
          _MockHasCardId(1),
          _MockHasCardId(2)
        ];
        cardTracker.mockCardsInMyDealRegion = cardsInMyDealRegion;

        selector.onNewEvent(CardStateMachineEvent.tapOnMyDealRegion);

        for (var i = 0; i < 2; i++) {
          s.receivedEvents[i] = CardEvent.pickUp;
          s.receivedPayloads[i] = CardEventPickUpPayload(
              cardsInMyDealRegion[i].cardId,
              orderIndex: i);
        }
      });
    });
  });
}
