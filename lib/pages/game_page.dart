import 'package:flutter/material.dart';

import '../repositories/game_repository.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    Key? key,
    required this.gameRepository,
  }) : super(key: key);

  final GameRepository gameRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Container(),
    );
  }
}
