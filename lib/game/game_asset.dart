import 'dart:ui';

import 'package:flame/flame.dart';

class GameAsset {
  static final cardSpriteNames =
      '''01,01,02,02,03,03,03,04,04,04,05,05,05,06,06,06,07,07,07,07,08,08,08,09,09,10,10,10,
        11,11,12,12,12,13,13,14,14,14,14,15,15,15,16,16,16,17,17,17,18,18,18,19,19,19,
        40,40,40,40,40,40,40,40,40,40,
        20,21,22,22,23,24,25,26,26,27,27,
        28,28,29,29,30,30,31,31,32,32,33,33,33,
        34,34,34,34,34,34,
        35,35,35,35,35,
        36,36,36,37,37,37,38,38,39'''
          .split(',');

  final Map<int, int> _indexToId = {};

  Future<void> load() async {
    await Flame.images.loadAllImages();
  }

  void onCardRevealed(int index, int id) {
    _indexToId[index] = id;
  }

  Image frontImageForCardIndex(int index) {
    final id = _indexToNotNullId(index);
    return Flame.images.fromCache('${cardSpriteNames[id].trim()}.png');
  }

  int indexToCardType(int index) {
    return int.parse(cardSpriteNames[_indexToNotNullId(index)]);
  }

  int _indexToNotNullId(int index) {
    final id = _indexToId[index];
    if (id == null) throw StateError('Card at $index has not been revealed');
    return id;
  }
}
