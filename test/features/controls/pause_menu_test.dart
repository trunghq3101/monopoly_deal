import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/features/controls/pause_menu.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';
import 'package:monopoly_deal/routes.dart';

import '../../utils.dart';

void main() {
  group('PauseMenu', () {
    testWidgets('cancel', (tester) async {
      final game = StubMainGame()
        ..pauseEngine()
        ..overlays.addEntry(Overlays.kPauseMenu, (context, game) => Container())
        ..overlays.add(Overlays.kPauseMenu);
      await tester.pumpWidget(MaterialApp(home: PauseMenu(game: game)));
      await tester.tap(find.text('Cancel'));
      expect(game.paused, false);
      expect(game.overlays.isActive(Overlays.kPauseMenu), false);
    });

    testWidgets('quit', (tester) async {
      final game = StubMainGame();
      await tester.pumpWidget(MaterialApp(
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.game);
                },
                child: const Text('open pause menu'),
              ),
          AppRoutes.game: (_) => PauseMenu(game: game),
        },
      ));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quit game'));
      await tester.pumpAndSettle();
      expect(find.text('open pause menu'), findsOneWidget);
      //TODO: expect game model to be reset
    });
  });
}
