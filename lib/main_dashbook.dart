import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/dev/game_wrapper.dart';
import 'package:monopoly_deal/dev/table_layout_game.dart';
import 'package:monopoly_deal/game_components/base_game.dart';
import 'package:monopoly_deal/game_components/hand.dart';

void main() {
  final dashbook = Dashbook();

  dashbook.storiesOf('2 players game').add(
    'overview',
    (ctx) {
      final game = TableLayoutGame();
      return GameWrapper(game: game);
    },
  ).add(
    'hand',
    (ctx) {
      final game = BaseGame()
        ..onDebug((game) {
          game.viewport.add(Hand());
        });
      ctx.action('hide', (_) {});
      return GameWrapper(game: game);
    },
  ).add(
    'peek the card',
    (ctx) {
      return Container();
    },
  ).add(
    'opponent pick up cards',
    (ctx) {
      return Container();
    },
  );

  runApp(dashbook);
}
