import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game_components/deck.dart';
import 'package:monopoly_deal/game_components/effects/camera_zoom_effect.dart';

void main() {
  group('Deck', () {
    testWithFlameGame('deal', (game) async {
      final tt = [
        PositionComponent(position: Vector2(0, 500))..addToParent(game),
        PositionComponent(position: Vector2(500, 0))..addToParent(game),
        PositionComponent(position: Vector2(0, -500))..addToParent(game)
      ];
      final c = Deck(dealTargets: tt)..addToParent(game);
      final cam = CameraComponent(world: World())..addToParent(game);
      await game.ready();
      game.update(1.5);
      await game.ready();
      expect(c.children.length, 110);
      final cc = c.children.skip(95).toList();
      c.deal();
      await game.ready();
      expect(cam.firstChild<CameraZoomEffect>(), isNotNull);
      expect(
        cc.every((c) => c.firstChild<Effect>() != null),
        true,
      );
    });
  });
}
