import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class _MockPublisher extends PublisherComponent {}

class _MockSubscriberComponent extends Component with Subscriber {
  Event? receivedEvent;

  @override
  void onNewEvent(event) {
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
        publisher.notify(Event(1));

        expect(sRemaining.receivedEvent, Event(1));
        expect(sToRemoved.receivedEvent, Event(1));

        p.remove(sToRemoved);
        await game.ready();
        publisher.notify(Event(2));

        expect(sRemaining.receivedEvent, Event(2));
        expect(sToRemoved.receivedEvent, Event(1));
      },
    );

    test('onRemove, clear subscribers', () {
      final s0 = _MockSubscriberComponent();
      final s1 = _MockSubscriberComponent();
      publisher.addSubscriber(s0);
      publisher.addSubscriber(s1);
      publisher.notify(Event(1));

      expect(s0.receivedEvent, Event(1));
      expect(s1.receivedEvent, Event(1));

      publisher.onRemove();
      publisher.notify(Event(2));

      expect(s0.receivedEvent, Event(1));
      expect(s1.receivedEvent, Event(1));
    });
  });
}
