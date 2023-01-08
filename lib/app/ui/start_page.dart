import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/app/lib/lib.dart';
import 'package:monopoly_deal/game/game.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameWidget(game: MainGame2()),
        const StartMenuOverlay(),
      ],
    );
  }
}

class StartMenuOverlay extends StatefulWidget {
  const StartMenuOverlay({super.key});

  @override
  State<StartMenuOverlay> createState() => _StartMenuOverlayState();
}

class _StartMenuOverlayState extends State<StartMenuOverlay> {
  late final Timer _timer;
  bool _show = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _show = true;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_show) return const SizedBox.shrink();
    return Material(
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
        const StartMenu()
      ]),
    );
  }
}

class StartMenu extends StatelessWidget {
  const StartMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return M3Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(builder: (context) {
            return TextButton(
              onPressed: () {
                RoomModel.of(context).createRoom();
                Navigator.of(context).pushNamed('/waitingRoom');
              },
              child: const Text('Create room'),
            );
          }),
          const SizedBox(height: 12),
          Builder(builder: (context) {
            return TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/joinRoom');
              },
              child: const Text('Join room'),
            );
          }),
        ],
      ),
    );
  }
}
