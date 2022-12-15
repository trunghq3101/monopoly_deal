import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class _MockGame extends FlameGame with HasTappableComponents {}

class _MockSubscriber implements Subscriber {
  Object? receivedEvent;

  @override
  void onNewEvent(Object event, [Object? payload]) {
    receivedEvent = event;
  }
}

void main() {
  group('$HandToggleButton', () {
    late HandToggleButton button;

    setUp(() {
      button = HandToggleButton();
    });

    testWithGame<_MockGame>(
      'run correctly',
      _MockGame.new,
      (game) async {
        await game.ensureAdd(button);
        final s = _MockSubscriber();
        button.addSubscriber(s);

        button.onNewEvent(CardStateMachineEvent.pickUpToHand);
        await game.ready();
        game.update(2);

        button.onTapDown(createTapDownEvents());
        expect(s.receivedEvent, HandToggleButtonEvent.tapHide);

        button.onTapDown(createTapDownEvents());
        expect(s.receivedEvent, HandToggleButtonEvent.tapShow);
      },
    );
  });
}
