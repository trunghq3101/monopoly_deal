import 'package:flame/game.dart';
import 'package:flutter/material.dart';

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
