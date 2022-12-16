import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

enum PlaceCardButtonState {
  visible,
  invisible,
}

class PlaceCardButton extends PositionComponent with TapCallbacks, Subscriber {
  PlaceCardButtonState _state = PlaceCardButtonState.invisible;
  PlaceCardButtonState get state => _state;

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.bottomRight;
    size = Vector2(380, 200);
  }

  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.toPreviewing:
        if (state == PlaceCardButtonState.invisible) {
          _changeState(PlaceCardButtonState.visible);
        }
        break;
      case CardStateMachineEvent.toHand:
        if (state == PlaceCardButtonState.visible) {
          _changeState(PlaceCardButtonState.invisible);
        }
        break;
      default:
    }
  }

  void _changeState(PlaceCardButtonState state) {
    _state = state;
    switch (_state) {
      case PlaceCardButtonState.invisible:
        children.query<ButtonComponent>().firstOrNull?.removeFromParent();
        break;
      case PlaceCardButtonState.visible:
        add(ButtonComponent(text: "PLAY"));
        break;
      default:
    }
  }
}
