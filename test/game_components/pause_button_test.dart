import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';
import 'package:monopoly_deal/game_components/pause_button.dart';

import '../utils.dart';

final game = FlameTester(
  StubMainGame.new,
  createGameWidget: (StubMainGame game) => GameWidget(
    game: game,
    overlayBuilderMap: {
      Overlays.kPauseMenu: (_, __) => const Text('Pausing'),
    },
  ),
);

void main() {
  game.testGameWidget(
    'pause',
    setUp: (game, _) async {
      await gameAssets.load();
      await game.ensureAdd(PauseBtnComponent());
    },
    verify: (game, tester) async {
      await tester.tapAt(const Offset(10, 10));
      await tester.pump(const Duration(seconds: 1));
      expect(game.overlays.isActive(Overlays.kPauseMenu), true);
      expect(game.paused, true);
    },
  );
}
