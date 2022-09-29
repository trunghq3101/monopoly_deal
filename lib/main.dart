import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/dev/repositories.dart';
import 'package:monopoly_deal/main_game.dart';
import 'package:monopoly_deal/pages/game_page.dart';
import 'package:monopoly_deal/repositories/game_repository.dart';
import 'package:monopoly_deal/routes.dart';

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
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => HomePage(gameRepository: gameRepository),
        AppRoutes.game: (_) => GameWidget(game: MainGame()),
      },
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
