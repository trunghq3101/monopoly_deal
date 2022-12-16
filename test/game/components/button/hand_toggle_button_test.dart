import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

import '../../../utils.dart';

class _MockGame extends FlameGame with HasTappableComponents {}

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
        final s = MockSingleEventSubscriber();
        button.addSubscriber(s);

        button.onNewEvent(Event(CardStateMachineEvent.pickUpToHand));
        await game.ready();
        game.update(2);

        button.onTapDown(createTapDownEvents());
        expect(s.receivedEvent, Event(HandToggleButtonEvent.tapHide));

        button.onTapDown(createTapDownEvents());
        expect(s.receivedEvent, Event(HandToggleButtonEvent.tapShow));
      },
    );

    testWithGame<_MockGame>(
      'show/hide on ${CardStateMachineEvent.toHand}/${CardStateMachineEvent.toPreviewing}',
      _MockGame.new,
      (game) async {
        await game.ensureAdd(button);

        button.onNewEvent(Event(CardStateMachineEvent.pickUpToHand));
        await game.ready();
        game.update(2);

        button.onNewEvent(Event(CardStateMachineEvent.toPreviewing));
        await game.ready();
        game.update(2);
        expect(button.state, HandToggleButtonState.invisible);

        button.onNewEvent(Event(CardStateMachineEvent.toHand));
        await game.ready();
        game.update(2);
        expect(button.state, HandToggleButtonState.hide);
      },
    );
  });
}
