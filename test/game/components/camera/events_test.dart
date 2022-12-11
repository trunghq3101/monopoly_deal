import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class _MockSubscriber implements Subscriber<CameraEvent> {
  CameraEvent? receivedEvent;

  @override
  void onNewEvent(CameraEvent event, [Object? payload]) {
    receivedEvent = event;
  }
}

void main() {
  group('$CardDeckEventToCameraEventAdapter', () {
    late CardDeckEventToCameraEventAdapter adapter;
    late _MockSubscriber subscriber;

    setUp(() {
      adapter = CardDeckEventToCameraEventAdapter();
      subscriber = _MockSubscriber();
      adapter.addSubscriber(subscriber);
    });

    test(
      'on ${CardDeckEvent.dealStartGame}, notify ${CameraEvent.toOverview}',
      () {
        adapter.onNewEvent(CardDeckEvent.dealStartGame);

        expect(subscriber.receivedEvent, CameraEvent.toOverview);
      },
    );
  });
}
