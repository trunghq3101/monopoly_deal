import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/game_components/card.dart' as card_component;
import 'package:monopoly_deal/main_game.dart';

extension _DebugControl on MainGame {
  Viewfinder get viewfinder =>
      children.query<CameraComponent>().first.viewfinder;

  Deck get deck => children.query<World>().first.children.query<Deck>().first;
}

class DebugBoard extends StatelessWidget {
  const DebugBoard({super.key, required this.mainGame});

  final MainGame mainGame;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.3,
      widthFactor: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          runSpacing: 16,
          spacing: 16,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hide'),
            ),
            ElevatedButton(
              onPressed: () {
                final vSize = mainGame.viewfinder.visibleGameSize!;
                mainGame.viewfinder.visibleGameSize = vSize * 1.1;
              },
              child: const Text('Zoom out'),
            ),
            ElevatedButton(
              onPressed: () {
                mainGame.viewfinder.visibleGameSize =
                    card_component.Card.kCardSize * 1.2;
                mainGame.children.query<CameraComponent>().first.moveTo(mainGame
                    .deck.children
                    .query<card_component.Card>()
                    .first
                    .position);
              },
              child: const Text('Reset zoom'),
            ),
            ElevatedButton(
              onPressed: () {
                mainGame.deck.children
                    .query<card_component.Card>()
                    .first
                    .deal(by: Vector2(0, -4000));
                Navigator.of(context).pop();
              },
              child: const Text('Deal'),
            )
          ],
        ),
      ),
    );
  }
}
