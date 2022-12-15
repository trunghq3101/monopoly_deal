import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class _MockPublisher extends PublisherComponent {}

class _MockSubscriberComponent extends Component with Subscriber {
  Object? receivedEvent;

  @override
  void onNewEvent(event, [Object? payload]) {
    receivedEvent = event;
  }
}

void main() {
  group('Publisher', () {
    late PublisherComponent publisher;

    setUp(() {
      publisher = _MockPublisher();
    });

    testWithFlameGame(
      'remove removed components during the next notify()',
      (game) async {
        final sRemaining = _MockSubscriberComponent();
        final sToRemoved = _MockSubscriberComponent();
        final p = Component();
        p.add(sToRemoved);
        await game.ensureAdd(p);
        await game.ensureAdd(sRemaining);
        publisher.addSubscriber(sRemaining);
        publisher.addSubscriber(sToRemoved);
        publisher.notify(1);

        expect(sRemaining.receivedEvent, 1);
        expect(sToRemoved.receivedEvent, 1);

        p.remove(sToRemoved);
        await game.ready();
        publisher.notify(2);

        expect(sRemaining.receivedEvent, 2);
        expect(sToRemoved.receivedEvent, 1);
      },
    );

    test('onRemove, clear subscribers', () {
      final s0 = _MockSubscriberComponent();
      final s1 = _MockSubscriberComponent();
      publisher.addSubscriber(s0);
      publisher.addSubscriber(s1);
      publisher.notify(1);

      expect(s0.receivedEvent, 1);
      expect(s1.receivedEvent, 1);

      publisher.onRemove();
      publisher.notify(2);

      expect(s0.receivedEvent, 1);
      expect(s1.receivedEvent, 1);
    });
  });
}
