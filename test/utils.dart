import 'dart:io';
import 'dart:math';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

class StubMainGame extends FlameGame with HasTappableComponents {}

extension DoubleRound on double {
  double toFixed(int fractionDigits) {
    num mod = pow(10.0, fractionDigits);
    return ((this * mod).round().toDouble() / mod);
  }
}

class MockAssetBundle extends AssetBundle {
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
