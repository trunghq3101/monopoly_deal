import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';
import 'package:monopoly_deal/main_game.dart';
import 'package:monopoly_deal/widgets/debug_board.dart';
import 'package:monopoly_deal/widgets/pause_menu.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final mainGame = MainGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton.small(
            onPressed: () {
              showBottomSheet(
                context: context,
                builder: (context) {
                  return DebugBoard(mainGame: mainGame);
                },
              );
            },
            child: const Icon(Icons.bug_report),
          );
        },
      ),
      body: GameWidget(
        game: mainGame,
        overlayBuilderMap: {
          Overlays.kPauseMenu: (_, MainGame game) => PauseMenu(game: game),
        },
      ),
    );
  }
}
