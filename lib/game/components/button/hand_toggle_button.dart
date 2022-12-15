import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class HandToggleButton extends PositionComponent with Publisher, TapCallbacks {
  late _State _state;

  @override
  Future<void>? onLoad() async {
    anchor = Anchor.bottomRight;
    size = Vector2(380, 160);
    _changeState(_State.hide);
  }

  @override
  void onTapDown(TapDownEvent event) {
    switch (_state) {
      case _State.hide:
        _changeState(_State.show);
        notify(HandToggleButtonEvent.tapHide);
        break;
      case _State.show:
        _changeState(_State.hide);
        notify(HandToggleButtonEvent.tapShow);
        break;
      default:
    }
  }

  void _changeState(_State state) {
    _state = state;
    children.query<ButtonComponent>().firstOrNull?.removeFromParent();
    add(ButtonComponent(text: _state.name.toUpperCase()));
  }
}

enum _State { hide, show }
