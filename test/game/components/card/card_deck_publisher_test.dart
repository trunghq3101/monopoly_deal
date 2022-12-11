import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class _MockSubscriber implements Subscriber<CardDeckEvent> {
  CardDeckEvent? receivedEvent;

  @override
  void onNewEvent(CardDeckEvent event, [Object? payload]) =>
      receivedEvent = event;
}

void main() {
  group('$CardDeckPublisher', () {
    late CardDeckPublisher publisher;

    setUp(() {
      publisher = CardDeckPublisher();
    });

    test('is ${Subscriber<AddToDeckEvent>}', () {
      expect(publisher, isA<Subscriber<AddToDeckEvent>>());
    });

    testWithFlameGame('at 0s, notify ${CardDeckEvent.showUp}', (game) async {
      final s = _MockSubscriber();
      publisher.addSubscriber(s);
      await game.ensureAdd(publisher);

      game.update(0);

      expect(s.receivedEvent, CardDeckEvent.showUp);
    });

    testWithFlameGame(
        'receive ${AddToDeckEvent.done} for ${MainGame2.cardTotalAmount} times, notify ${CardDeckEvent.dealStartGame}',
        (game) async {
      final s = _MockSubscriber();
      publisher.addSubscriber(s);
      await game.ensureAdd(publisher);

      for (var i = 0; i < MainGame2.cardTotalAmount; i++) {
        publisher.onNewEvent(AddToDeckEvent.done);
      }

      expect(s.receivedEvent, CardDeckEvent.dealStartGame);
    });
  });
}
