import 'package:flame/extensions.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

import '../../utils.dart';

class _MockCardTracker extends CardTracker {
  List<HasCardId> mockCardsInHand = [];
  List<InHandPosition> mockInHandPosition = [];

  @override
  List<HasCardId> cardsInHandCollapsedFromTop() => mockCardsInHand;

  @override
  InHandPosition getInHandCollapsedPosition({
    required int index,
    required int amount,
  }) =>
      mockInHandPosition[index];
}

class _MockHasCardId implements HasCardId {
  _MockHasCardId(this._cardId);

  final int _cardId;

  @override
  int get cardId => _cardId;
}

void main() {
  group('$SelectToReArrange', () {
    late SelectToReArrange selector;
    late _MockCardTracker cardTracker;

    setUp(() {
      cardTracker = _MockCardTracker();
      selector = SelectToReArrange(cardTracker: cardTracker);
    });

    testWithFlameGame(
        'on ${PlaceCardButtonEvent.tap}, notify ${CardEvent.reposition} to cardsInHand',
        (game) async {
      final s = MockSequenceEventSubscriber();
      selector.addSubscriber(s);
      final mockInHandPosition = [
        InHandPosition(Vector2.all(10), 0.1),
        InHandPosition(Vector2.all(20), 0.2)
      ];
      cardTracker.mockCardsInHand = [_MockHasCardId(0), _MockHasCardId(1)];
      cardTracker.mockInHandPosition = mockInHandPosition;
      await game.ensureAdd(selector);

      selector.onNewEvent(Event(PlaceCardButtonEvent.tap));
      await game.ready();
      game.update(2);

      expect(s.receivedEvents, [
        Event(CardEvent.reposition)
          ..payload =
              CardRepositionPayload(0, inHandPosition: mockInHandPosition[1]),
        Event(CardEvent.reposition)
          ..payload =
              CardRepositionPayload(1, inHandPosition: mockInHandPosition[0]),
      ]);
    });
  });
}
