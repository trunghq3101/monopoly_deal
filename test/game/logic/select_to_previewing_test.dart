import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

import '../../utils.dart';

class _MockCardTracker extends CardTracker {
  Card? mockCardInPreviewingState;

  @override
  Card? cardInPreviewingState() => mockCardInPreviewingState;
}

void main() {
  group('$SelectToPreviewing', () {
    late SelectToPreviewing selector;
    late _MockCardTracker cardTracker;
    late MockSequenceEventSubscriber subscriber;

    setUp(() {
      cardTracker = _MockCardTracker();
      selector = SelectToPreviewing(cardTracker: cardTracker);
      subscriber = MockSequenceEventSubscriber();
      selector.addSubscriber(subscriber);
    });

    group('on ${CardStateMachineEvent.tapWhileInHand}', () {
      test(
          'given no previewing card, notify ${CardEvent.preview} with cardIndex',
          () {
        const cardIndex = 2;
        cardTracker.mockCardInPreviewingState = null;

        selector.onNewEvent(
          Event(CardStateMachineEvent.tapWhileInHand)
            ..payload = CardIndexPayload(cardIndex),
        );

        expect(subscriber.receivedEvents[0],
            Event(CardEvent.preview)..payload = CardIndexPayload(cardIndex));
      });

      test(
          'given a previewing card, notify ${CardEvent.preview} and ${CardEvent.previewSwap}',
          () {
        const cardIndex = 2;
        const previewingCardId = 1;
        cardTracker.mockCardInPreviewingState =
            Card(cardIndex: previewingCardId);

        selector.onNewEvent(
          Event(CardStateMachineEvent.tapWhileInHand)
            ..payload = CardIndexPayload(cardIndex),
        );

        expect(
          subscriber.receivedEvents,
          [
            Event(CardEvent.preview)..payload = CardIndexPayload(cardIndex),
            Event(CardEvent.previewSwap)
              ..payload = CardIndexPayload(previewingCardId),
          ],
        );
      });
    });

    group('on ${CardStateMachineEvent.tapWhileInPreviewing}', () {
      test('notify ${CardEvent.previewRevert} with cardIndex', () {
        const cardIndex = 2;

        selector.onNewEvent(
          Event(CardStateMachineEvent.tapWhileInPreviewing)
            ..payload = CardIndexPayload(cardIndex),
        );

        expect(
            subscriber.receivedEvents[0],
            Event(CardEvent.previewRevert)
              ..payload = CardIndexPayload(cardIndex));
      });
    });
  });
}
