import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/app/lib/lib.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final GameRoomNotifier _gameRoomNotifier = GameRoomNotifier();

  @override
  void dispose() {
    _gameRoomNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameRoomModel(
      notifier: _gameRoomNotifier,
      child: Material(
        color: Colors.transparent,
        child: Stack(children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: M3Duration.short4,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: child,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: const ColoredBox(
                color: Colors.black54,
              ),
            ),
          ),
          Navigator(
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                    builder: (_) => const StartMenu(),
                    settings: settings,
                  );
                case '/waitingRoom':
                  return MaterialPageRoute(
                    builder: (_) => const WaitingRoom(),
                    settings: settings,
                  );

                case '/joinRoom':
                  return MaterialPageRoute(
                    builder: (_) => const JoinRoom(),
                    settings: settings,
                  );
                default:
                  throw ArgumentError();
              }
            },
          )
        ]),
      ),
    );
  }
}
