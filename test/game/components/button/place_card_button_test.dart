import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

import '../../../utils.dart';

void main() {
  late PlaceCardButton button;

  setUp(() {
    button = PlaceCardButton();
  });

  group('$PlaceCardButton', () {
    test('on ${CardStateMachineEvent.toPreviewing}, change to visible state',
        () {
      button.onNewEvent(Event(CardStateMachineEvent.toPreviewing));

      expect(button.state, PlaceCardButtonState.visible);
    });

    test('on ${CardStateMachineEvent.toHand}, change to invisible state', () {
      button.onNewEvent(Event(CardStateMachineEvent.toHand));

      expect(button.state, PlaceCardButtonState.invisible);
    });

    test(
        'on tap, in visible state, notify ${PlaceCardButtonEvent.tap}, change to invisible state',
        () {
      final s = MockSingleEventSubscriber();
      button.addSubscriber(s);
      button.onNewEvent(Event(CardStateMachineEvent.toPreviewing));

      button.onTapDown(createTapDownEvents());

      expect(button.state, PlaceCardButtonState.invisible);
      expect(s.receivedEvent, Event(PlaceCardButtonEvent.tap));
    });
  });
}
