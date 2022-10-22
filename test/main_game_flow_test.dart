import 'dart:ui';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game_components/card.dart';
import 'package:monopoly_deal/game_components/deck.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';
import 'package:monopoly_deal/game_components/main_game.dart';
import 'package:monopoly_deal/models/game_model.dart';

void main() {
  late GameModel gameModel;
  int seed = 0;

  setUp(() {
    gameAssets.randomSeed = () => ++seed;
    gameModel = GameModel.fromJson({
      "players": [],
      "step": "idle",
      "moves": [],
    });
  });

  testWidgets(
    'play until win',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 640));
      final game = MainGame(gameModel)..debugMode = false;
      final widget = GameWidget(game: game);
      await tester.pumpWidget(widget);

      // Show deck
      for (var i = 0; i < 110; i++) {
        game.update(0.01);
        await tester.pump();
      }
      expect(
          game.world.children.query<Deck>().first.children.query<Card>().length,
          110);
      await expectLater(
        find.byWidget(widget),
        matchesGoldenFile('_goldens/show_deck.png'),
      );

      // Deal 5 cards to each player
      await tester.pumpFrames(widget, const Duration(seconds: 4));
      await expectLater(
        find.byWidget(widget),
        matchesGoldenFile('_goldens/deal_cards.png'),
      );

      // Show cards of my player
      game.onTapDown(
        TapDownEvent(
          0,
          TapDownDetails(globalPosition: const Offset(180, 600)),
        ),
      );
      // expect 5 cards in hand

      // Draw 2 cards;
      // Place 3 cards
      // End turn
      // Opponent draw 2 cards
      // Opponent place 3 cards
      // End turn
      // Draw 2 cards
      // Place 3 cards
      // End turn
      // Opponent draw 2 cards
      // Opponent place 3 cards
      // End turn
      // Draw 2 cards
      // Place 3 cards
      // I win
    },
  );
}
