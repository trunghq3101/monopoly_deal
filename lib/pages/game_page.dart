import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';
import 'package:monopoly_deal/main_game.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MainGame(),
      overlayBuilderMap: {
        Overlays.kPauseMenu: (_, __) => const Text('Pausing'),
      },
    );
  }
}
