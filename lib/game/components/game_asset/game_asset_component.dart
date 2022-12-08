import 'dart:ui';

import 'package:flame/flame.dart';

class GameAsset {
  Image image(String name) {
    return Flame.images.fromCache(name);
  }
}
