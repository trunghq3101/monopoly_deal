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
      final image = await generateImage();
      final tt = [
        PositionComponent(position: Vector2(0, 500))..addToParent(game),
        PositionComponent(position: Vector2(500, 0))..addToParent(game),
        PositionComponent(position: Vector2(0, -500))..addToParent(game)
      ];
      final c = Deck(dealTargets: tt, cardSprite: Sprite(image))
        ..addToParent(game);
      final cam = CameraComponent(world: World())..addToParent(game);
      cam.viewfinder.visibleGameSize = Vector2.all(1000);
      await game.ready();
      game.update(1.5);
      await game.ready();
      expect(c.children.length, 106);
      final cc = c.children.skip(91).toList();
      c.deal();
      await game.ready();
      expect(cam.firstChild<CameraZoomEffect>(), isNotNull);
      expect(
        cc.every((c) => c.firstChild<Effect>() != null),
        true,
      );
      game.update(10);
      await game.ready();
      expect(tt[0].children, [cc[14], cc[11], cc[8], cc[5], cc[2]]);
      expect(tt[1].children, [cc[13], cc[10], cc[7], cc[4], cc[1]]);
      expect(tt[2].children, [cc[12], cc[9], cc[6], cc[3], cc[0]]);
    });
  });
}
