import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/dev/play_ground_page.dart';
import 'package:monopoly_deal/dev/table_layout_game.dart';

void main() {
  final dashbook = Dashbook();

  dashbook.storiesOf('2 players table').add('overview', (ctx) {
    ctx.action('deal', (context) {});
    final game = TableLayoutGame();
    return GameWrapper(game: game);
  });

  runApp(dashbook);
}
