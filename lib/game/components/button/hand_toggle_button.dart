import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class HandToggleButton extends PositionComponent with Subscriber, Publisher {
  HandToggleButtonState _state = HandToggleButtonState.invisible;
  HandToggleButtonState get state => _state;

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.bottomRight;
    size = MainGame.gameMap.buttonSize;
    scale = Vector2.zero();
  }

  void _onTapDown(TapDownEvent event) {
    switch (state) {
      case HandToggleButtonState.hide:
        _changeState(HandToggleButtonState.show);
        notify(Event(HandToggleButtonEvent.tapHide));
        break;
      case HandToggleButtonState.show:
        _changeState(HandToggleButtonState.hide);
        notify(Event(HandToggleButtonEvent.tapShow));
        break;
      default:
    }
  }

  void _changeState(HandToggleButtonState state) {
    _state = state;
    children.query<ButtonComponent>().firstOrNull?.removeFromParent();
    if (state == HandToggleButtonState.invisible) return;
    add(ButtonComponent(text: state.name.toUpperCase(), tapDown: _onTapDown));
  }

  @override
  void onNewEvent(Event event) {
    switch (state) {
      case HandToggleButtonState.invisible:
        switch (event.eventIdentifier) {
          case CardStateMachineEvent.pickUpToHand:
            _changeState(HandToggleButtonState.hide);
            add(ScaleEffect.to(
              Vector2.all(1),
              EffectController(duration: 0.1, startDelay: 0.8),
            ));
            break;
          case CardStateMachineEvent.toHand:
            _changeState(HandToggleButtonState.hide);
            add(ScaleEffect.to(
              Vector2.all(1),
              EffectController(duration: 0.1),
            ));
            break;
          case PlaceCardButtonEvent.tap:
            _changeState(HandToggleButtonState.show);
            add(ScaleEffect.to(
              Vector2.all(1),
              EffectController(duration: 0.1),
            ));
            break;
          case DiscardAreaEvent.cancel:
            _changeState(HandToggleButtonState.hide);
            add(ScaleEffect.to(
              Vector2.all(1),
              EffectController(duration: 0.1),
            ));
            break;
          default:
        }
        break;
      case HandToggleButtonState.show:
        switch (event.eventIdentifier) {
          case CardDeckEvent.pickUp:
            _changeState(HandToggleButtonState.hide);
            break;
          case CardStateMachineEvent.toPreviewing:
            _changeState(HandToggleButtonState.invisible);
            add(ScaleEffect.to(
              Vector2.all(0),
              EffectController(duration: 0.1),
            ));
            break;
          case PassTurnButtonEvent.needDiscard:
            notify(Event(HandToggleButtonEvent.tapShow));
            _changeState(HandToggleButtonState.invisible);
            add(ScaleEffect.to(
              Vector2.all(0),
              EffectController(duration: 0.1),
            ));
            break;
          default:
        }
        break;
      default:
        switch (event.eventIdentifier) {
          case CardStateMachineEvent.toPreviewing:
          case PassTurnButtonEvent.needDiscard:
            _changeState(HandToggleButtonState.invisible);
            add(ScaleEffect.to(
              Vector2.all(0),
              EffectController(duration: 0.1),
            ));
            break;
          default:
        }
        break;
    }
  }
}

enum HandToggleButtonState { invisible, hide, show }
