import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class _MockPublisher extends PublisherComponent<int> {}

class _MockSubscriberComponent extends Component with Subscriber<int> {
  _MockSubscriberComponent({required this.mockOnNewEvent});

  final Function(int) mockOnNewEvent;

  @override
  void onNewEvent(int event, [Object? payload]) => mockOnNewEvent(event);
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
        final sRemaining = _MockSubscriberComponent(
          mockOnNewEvent: expectAsync1((event) {}, count: 2),
        );
        final sToRemoved = _MockSubscriberComponent(
          mockOnNewEvent: expectAsync1((event) {}),
        );
        final p = Component();
        p.add(sToRemoved);
        await game.ensureAdd(p);
        await game.ensureAdd(sRemaining);
        publisher.addSubscriber(sRemaining);
        publisher.addSubscriber(sToRemoved);
        publisher.notify(1);
        p.remove(sToRemoved);
        await game.ready();
        publisher.notify(2);
      },
    );

    test('onRemove, clear subscribers', () {
      final s0 = _MockSubscriberComponent(
        mockOnNewEvent: expectAsync1((event) {}),
      );
      final s1 = _MockSubscriberComponent(
        mockOnNewEvent: expectAsync1((event) {}),
      );
      publisher.addSubscriber(s0);
      publisher.addSubscriber(s1);
      publisher.notify(1);
      publisher.onRemove();
      publisher.notify(2);
    });
  });
}
