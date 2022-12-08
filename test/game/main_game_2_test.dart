import 'dart:io';

import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';

class _MockAssetBundle extends AssetBundle {
  @override
  Future<ByteData> load(String key) async {
    final bytes = await File(key).readAsBytes();
    return ByteData.view(bytes.buffer);
  }

  @override
  Future<T> loadStructuredData<T>(
      String key, Future<T> Function(String value) parser) async {
    return await parser('');
  }
}

void main() {
  group('MainGame2', () {
    setUp(() {
      Flame.bundle = _MockAssetBundle();
    });

    testWithGame<MainGame2>(
      'load correctly',
      MainGame2.new,
      (game) async {
        expect(game.children.query<World>(), isNotEmpty);
        expect(game.children.query<CameraComponent>(), isNotEmpty);
        expect(game.children.query<GameMap>(), isNotEmpty);
        expect(game.world.children.query<Card>().length, 110);
        expect(game.children.query<CardDeckPublisher>(), isNotEmpty);
      },
    );
  });
}
