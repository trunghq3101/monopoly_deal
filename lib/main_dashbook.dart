import 'package:dashbook/dashbook.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/dev/game_wrapper.dart';
import 'package:monopoly_deal/dev/table_layout_game.dart';
import 'package:monopoly_deal/game_components/base_game.dart';
import 'package:monopoly_deal/game_components/hand.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

class TestComponent extends PositionComponent
    with TapCallbacks, TapOutsideCallback {
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    print('Component tapped');
  }

  @override
  void onTapOutside() {
    print('Component outside');
  }
}

mixin TapOutsideCallback on Component {
  void onTapOutside() {}
}

void main() {
  final dashbook = Dashbook();

  dashbook.storiesOf('2 players game').add(
    'overview',
    (ctx) {
      final game = TableLayoutGame();
      return GameWrapper(game: game);
    },
  ).add('tap outside', (ctx) {
    final game = BaseGame()
      ..onDebug((game) {
        game.children.register<TapOutsideCallback>();
        game.add(TestComponent()..size = Vector2.all(400));
      });
    return GameWrapper(game: game);
  }).add(
    'hand',
    (ctx) {
      final hand = Hand();
      final game = BaseGame()
        ..onDebug((game) {
          game.add(hand);
        });
      ctx
        ..action('collapse', (_) {
          hand.onCommand(Command(kTapOutsideHand));
        })
        ..action('expand', (_) {
          hand.onCommand(Command(kTapInsideHand));
        });
      return GameWrapper(game: game);
    },
  ).add(
    'peek the card',
    (ctx) {
      final hand = Hand(children: []);
      final game = BaseGame()
        ..onDebug((game) {
          game.add(hand);
        });
      return GameWrapper(game: game);
    },
  ).add(
    'opponent pick up cards',
    (ctx) {
      return Container();
    },
  );

  runApp(dashbook);
}
