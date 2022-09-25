import 'package:flutter/material.dart';
import 'package:monopoly_deal/dev/repositories.dart';
import 'package:monopoly_deal/repositories/game_repository.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const DebugApp());
}

class MainApp extends StatelessWidget {
  const MainApp({
    Key? key,
    required this.gameRepository,
  }) : super(key: key);

  final GameRepository gameRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        gameRepository: gameRepository,
      ),
    );
  }
}

final _gameRepository = TestGameRepository();

class DebugApp extends StatelessWidget {
  const DebugApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Row(
        children: [
          Expanded(child: MainApp(gameRepository: _gameRepository)),
          const VerticalDivider(color: Colors.orange),
          Expanded(child: MainApp(gameRepository: _gameRepository)),
        ],
      ),
    );
  }
}
