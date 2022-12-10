import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class _MockSubscriber implements Subscriber<CardDeckEvent> {
  _MockSubscriber({required this.mockOnNewEvent});

  final Function(CardDeckEvent event) mockOnNewEvent;

  @override
  void onNewEvent(CardDeckEvent event, [Object? payload]) =>
      mockOnNewEvent(event);
}

void main() {
  group('$CardDeckPublisher', () {
    late CardDeckPublisher publisher;

    setUp(() {
      publisher = CardDeckPublisher();
    });

    testWithFlameGame('at 0s, notify $CardDeckEvent.showUp', (game) async {
      final expectation = expectAsync1((event) {
        expect(event, CardDeckEvent.showUp);
      });

      final s = _MockSubscriber(mockOnNewEvent: expectation);
      publisher.addSubscriber(s);
      await game.ensureAdd(publisher);
      game.update(0);
    });
  });
}
