import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';
import 'package:monopoly_deal/main_game.dart';
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
      final game = MainGame(gameModel);
      final widget = GameWidget(game: game);
      await tester.pumpWidget(widget);

      // Show deck
      await tester.pumpFrames(widget, const Duration(milliseconds: 500));
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
      // Draw 2 cards
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
