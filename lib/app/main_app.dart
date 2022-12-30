import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/game/game.dart';

final errorDisplayKey = GlobalKey<AppErrorDisplayState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(0, 15, 228, 232)),
      ),
      home: Stack(
        children: [
          AppErrorDisplay(key: errorDisplayKey),
          GameWidget(
            game: MainGame2(),
            overlayBuilderMap: {
              'startPage': (_, game) {
                return const StartPage();
              }
            },
          ),
        ],
      ),
    );
  }
}
