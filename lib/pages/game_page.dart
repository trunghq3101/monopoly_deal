import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';
import 'package:monopoly_deal/game_components/main_game.dart';
import 'package:monopoly_deal/models/game_model.dart';
import 'package:monopoly_deal/repositories/game_repository.dart';
import 'package:monopoly_deal/widgets/pause_menu.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.gameRepository});

  final GameRepository gameRepository;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  MainGame? mainGame;

  @override
  void initState() {
    super.initState();

    GameModel(players: [], step: Steps.idle, moves: [])
        .syncUp(widget.gameRepository)
        .then((value) => setState(() {
              mainGame = MainGame(value);
            }));
  }

  @override
  Widget build(BuildContext context) {
    final game = mainGame;
    return game == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        : Scaffold(
            body: GameWidget(
              game: game,
              overlayBuilderMap: {
                Overlays.kPauseMenu: (_, MainGame game) =>
                    PauseMenu(game: game),
              },
            ),
          );
  }
}
