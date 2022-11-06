import 'package:dashbook/dashbook.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/dev/game_wrapper.dart';
import 'package:monopoly_deal/dev/table_layout_game.dart';
import 'package:monopoly_deal/game_components/base_game.dart';
import 'package:monopoly_deal/game_components/hand.dart';
import 'package:monopoly_deal/game_components/tappable_overlay.dart';
import 'package:simple_state_machine/simple_state_machine.dart';

import 'dev/components.dart';

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
        game.add(TappableOverlay());
        game.add(TestComponent1()..size = Vector2.all(400));
        game.add(TestComponent2()
          ..size = Vector2.all(400)
          ..position = Vector2.all(500));
      });
    return GameWrapper(game: game);
  }).add(
    'hand',
    (ctx) {
      final hand = Hand();
      final game = BaseGame()
        ..onDebug((game) {
          game.add(TappableOverlay());
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
