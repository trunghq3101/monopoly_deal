import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

import '../../utils.dart';

class _MockCardTracker extends CardTracker {
  List<HasCardIndex> mockCardsInMyDealRegion = [];
  bool mockHasCardInAnimationState = false;
  @override
  List<HasCardIndex> cardsInMyDealRegionFromTop() => mockCardsInMyDealRegion;

  @override
  bool hasCardInAnimationState() => mockHasCardInAnimationState;
}

class _MockHasCardIndex implements HasCardIndex {
  _MockHasCardIndex(this._cardIndex);

  final int _cardIndex;

  @override
  int get cardIndex => _cardIndex;
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
      test('notify ${CardEvent.pickUp} with cardIndex and orderIndex', () {
        final s = MockSequenceEventSubscriber();
        selector.addSubscriber(s);
        final cardsInMyDealRegion = <HasCardIndex>[
          _MockHasCardIndex(1),
          _MockHasCardIndex(2)
        ];
        cardTracker.mockCardsInMyDealRegion = cardsInMyDealRegion;
        cardTracker.mockHasCardInAnimationState = false;

        selector.onNewEvent(Event(CardStateMachineEvent.tapOnMyDealRegion));

        for (var i = 0; i < 2; i++) {
          s.receivedEvents[i] = Event(CardEvent.pickUp)
            ..payload = CardPickUpPayload(cardsInMyDealRegion[i].cardIndex,
                orderIndex: i);
        }
      });

      test('given has animating cards, do nothing', () {
        final s = MockSequenceEventSubscriber();
        selector.addSubscriber(s);
        cardTracker.mockHasCardInAnimationState = true;

        selector.onNewEvent(Event(CardStateMachineEvent.tapOnMyDealRegion));

        expect(s.receivedEvents, isEmpty);
      });
    });
  });
}
