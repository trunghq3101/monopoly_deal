import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/dev/repositories.dart';
import 'package:monopoly_deal/pages/game_page.dart';
import 'package:monopoly_deal/repositories/game_repository.dart';
import 'package:monopoly_deal/routes.dart';

import 'firebase_options.dart';
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
        AppRoutes.game: (_) => GamePage(gameRepository: gameRepository),
      },
    );
  }
}

final _gameRepository = TestGameRepository();

final _firebaseInit = Firebase.initializeApp(
  name: 'lucky-deal',
  options: DefaultFirebaseOptions.currentPlatform,
);

class DebugApp extends StatelessWidget {
  const DebugApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
        future: _firebaseInit,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(
              home: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          return MaterialApp(
            home: Row(
              children: [
                Expanded(child: MainApp(gameRepository: _gameRepository)),
                const VerticalDivider(color: Colors.orange),
                Expanded(child: MainApp(gameRepository: _gameRepository)),
              ],
            ),
          );
        });
  }
}
