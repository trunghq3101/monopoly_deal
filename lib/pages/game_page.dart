import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';
import 'package:monopoly_deal/main_game.dart';
import 'package:monopoly_deal/widgets/pause_menu.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton.small(
            onPressed: () {
              showBottomSheet(
                context: context,
                builder: (context) {
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
                              Navigator.of(context).pop();
                            },
                            child: const Text('Deal'),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: const Icon(Icons.bug_report),
          );
        },
      ),
      body: GameWidget(
        game: MainGame(),
        overlayBuilderMap: {
          Overlays.kPauseMenu: (_, MainGame game) => PauseMenu(game: game),
        },
      ),
    );
  }
}
