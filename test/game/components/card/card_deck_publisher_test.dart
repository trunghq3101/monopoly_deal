import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

import '../../../utils.dart';

void main() {
  group('$CardDeckPublisher', () {
    late CardDeckPublisher publisher;
    late MockSingleEventSubscriber subscriber;

    setUp(() {
      publisher = CardDeckPublisher();
      subscriber = MockSingleEventSubscriber();
      publisher.addSubscriber(subscriber);
    });

    test('is $Subscriber', () {
      expect(publisher, isA<Subscriber>());
    });

    testWithFlameGame('at 0s, notify ${CardDeckEvent.showUp}', (game) async {
      await game.ensureAdd(publisher);

      game.update(0);

      expect(subscriber.receivedEvent, Event(CardDeckEvent.showUp));
    });

    testWithFlameGame(
        'receive ${CardEvent.addedToDeck} for ${MainGame.cardTotalAmount} times, notify ${CardDeckEvent.dealStartGame}',
        (game) async {
      await game.ensureAdd(publisher);

      for (var i = 0; i < MainGame.cardTotalAmount; i++) {
        publisher.onNewEvent(Event(CardEvent.addedToDeck));
      }

      expect(subscriber.receivedEvent, Event(CardDeckEvent.dealStartGame));
    });
  });
}
