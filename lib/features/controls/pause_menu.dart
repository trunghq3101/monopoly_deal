import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';
import 'package:monopoly_deal/routes.dart';

class PauseMenu extends StatelessWidget {
  const PauseMenu({super.key, required this.game});

  final FlameGame game;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('GAME PAUSED'),
      children: [
        SimpleDialogOption(
          onPressed: () => quit(context),
          child: const Text('Quit game'),
        ),
        SimpleDialogOption(
          onPressed: () => cancel(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  void cancel(BuildContext context) {
    game.resumeEngine();
    game.overlays.remove(Overlays.kPauseMenu);
  }

  void quit(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.home));
  }
}
