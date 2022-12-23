import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/game/game.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameWidget(
        game: MainGame2(),
        overlayBuilderMap: {
          'startMenu': (_, game) {
            return const StartMenu();
          }
        },
      ),
    );
  }
}
