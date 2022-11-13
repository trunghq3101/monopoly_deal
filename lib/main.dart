import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/pages/game_page.dart';
import 'package:monopoly_deal/routes.dart';

import 'firebase_options.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const FirebaseLoader(
    child: MainApp(),
  ));
}

class FirebaseLoader extends StatelessWidget {
  const FirebaseLoader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp?>(
        future: _firebaseInit,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(
              home: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          return child;
        });
  }
}

class MainApp extends StatelessWidget {
  const MainApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.game: (_) => const GamePage(),
      },
    );
  }
}

final _firebaseInit = (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux)
    ? Future.value(null)
    : Firebase.initializeApp(
        name: 'lucky-deal',
        options: DefaultFirebaseOptions.currentPlatform,
      );
