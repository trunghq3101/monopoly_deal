import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

import '../../utils.dart';

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

    test('is $Subscriber', () {
      expect(selector, isA<Subscriber>());
    });

    test('is $Publisher', () {
      expect(selector, isA<Publisher>());
    });

    group('on ${CardStateMachineEvent.tapOnMyDealRegion}', () {
      test('notify ${CardEvent.pickUp} with cardId and orderIndex', () {
        final s = MockSequenceEventSubscriber();
        selector.addSubscriber(s);
        final cardsInMyDealRegion = <HasCardId>[
          _MockHasCardId(1),
          _MockHasCardId(2)
        ];
        cardTracker.mockCardsInMyDealRegion = cardsInMyDealRegion;

        selector.onNewEvent(Event(CardStateMachineEvent.tapOnMyDealRegion));

        for (var i = 0; i < 2; i++) {
          s.receivedEvents[i] = Event(CardEvent.pickUp)
            ..payload =
                CardPickUpPayload(cardsInMyDealRegion[i].cardId, orderIndex: i);
        }
      });
    });
  });
}
