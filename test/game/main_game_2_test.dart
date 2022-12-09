import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';

import '../utils.dart';

void main() {
  group('MainGame2', () {
    setUp(() {
      Flame.bundle = MockAssetBundle();
    });

    testWithGame<MainGame2>(
      'load correctly',
      MainGame2.new,
      (game) async {
        await game.ready();
        expect(game.children.query<World>(), isNotEmpty);
        expect(game.children.query<CameraComponent>(), isNotEmpty);
        expect(game.children.query<GameMap>(), isNotEmpty);
        expect(game.world.children.query<Card>().length, 110);
        expect(game.children.query<CardDeckPublisher>(), isNotEmpty);
      },
    );
  });
}
