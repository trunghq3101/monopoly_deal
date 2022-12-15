import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class _MockCardTracker extends CardTracker {
  Card? mockCardInPreviewingState;

  @override
  Card? cardInPreviewingState() => mockCardInPreviewingState;
}

class _MockSubscriber implements Subscriber {
  List<Object?> receivedEvents = [];
  List<Object?> receivedPayloads = [];

  @override
  void onNewEvent(Object event, [Object? payload]) {
    receivedEvents.add(event);
    receivedPayloads.add(payload);
  }
}

void main() {
  group('$SelectToPreviewing', () {
    late SelectToPreviewing selector;
    late _MockCardTracker cardTracker;
    late _MockSubscriber subscriber;

    setUp(() {
      cardTracker = _MockCardTracker();
      selector = SelectToPreviewing(cardTracker: cardTracker);
      subscriber = _MockSubscriber();
      selector.addSubscriber(subscriber);
    });

    group('on ${CardStateMachineEvent.tapWhileInHand}', () {
      test('given no previewing card, notify ${CardEvent.preview} with cardId',
          () {
        const cardId = 2;
        cardTracker.mockCardInPreviewingState = null;

        selector.onNewEvent(
          CardStateMachineEvent.tapWhileInHand,
          CardIdPayload(cardId),
        );

        expect(subscriber.receivedEvents[0], CardEvent.preview);
        expect(
          subscriber.receivedPayloads[0],
          CardIdPayload(cardId),
        );
      });

      test(
          'given a previewing card, notify ${CardEvent.preview} and ${CardEvent.previewSwap}',
          () {
        const cardId = 2;
        const previewingCardId = 1;
        cardTracker.mockCardInPreviewingState = Card(cardId: previewingCardId);

        selector.onNewEvent(
          CardStateMachineEvent.tapWhileInHand,
          CardIdPayload(cardId),
        );

        expect(
          subscriber.receivedEvents,
          [CardEvent.preview, CardEvent.previewSwap],
        );
        expect(
          subscriber.receivedPayloads,
          [CardIdPayload(cardId), CardIdPayload(previewingCardId)],
        );
      });
    });

    group('on ${CardStateMachineEvent.tapWhileInPreviewing}', () {
      test('notify ${CardEvent.previewRevert} with cardId', () {
        const cardId = 2;

        selector.onNewEvent(
          CardStateMachineEvent.tapWhileInPreviewing,
          CardIdPayload(cardId),
        );

        expect(subscriber.receivedEvents[0], CardEvent.previewRevert);
        expect(
          subscriber.receivedPayloads[0],
          CardIdPayload(cardId),
        );
      });
    });
  });
}
