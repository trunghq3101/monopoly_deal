import 'package:flutter/material.dart';
import 'package:monopoly_deal/dev/repositories.dart';
import 'package:monopoly_deal/models/player.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const DebugApp());
}

final gameRepository = TestGameRepository();

class DebugApp extends StatelessWidget {
  const DebugApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Row(
        children: [
          // Expanded(
          //   child: MaterialApp(
          //     home: HomePage(
          //       game: GameRound(repository: gameRepository),
          //       player: Player(),
          //     ),
          //   ),
          // ),
          // const VerticalDivider(
          //   color: Colors.orange,
          // ),
          // Expanded(
          //   child: MaterialApp(
          //     home: HomePage(
          //       game: GameRound(repository: gameRepository),
          //       player: Player(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
