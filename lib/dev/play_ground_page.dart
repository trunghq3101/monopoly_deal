import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/dev/table_layout_game.dart';

class PlayGroundPage extends StatelessWidget {
  const PlayGroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Table layout'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => GameWrapper(game: TableLayoutGame())));
            },
          )
        ],
      ),
    );
  }
}

class GameWrapper extends StatelessWidget {
  const GameWrapper({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GameWidget(game: game),
    );
  }
}
