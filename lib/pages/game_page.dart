import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/features/controls/pause_menu.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';
import 'package:monopoly_deal/game_components/main_game.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: MainGame(),
        overlayBuilderMap: {
          Overlays.kPauseMenu: (_, MainGame game) => PauseMenu(game: game),
        },
      ),
    );
  }
}
