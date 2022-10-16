import 'package:flame/flame.dart';
import 'package:rive/rive.dart';

final gameAssets = GameAssets();

class GameAssets {
  int get randomSeed => _randomSeed ?? DateTime.now().millisecondsSinceEpoch;
  int? _randomSeed;
  final Map<String, RiveFile> _riveFiles = {};

  Future<void> preCache() async {
    _riveFiles['buttons'] = await RiveFile.asset('assets/images/buttons.riv');
    await Flame.assets.readFile('card.svg');
  }

  RiveFile riveFile(String name) => _riveFiles[name]!;

  void fixRandomSeed(int seed) {
    _randomSeed = seed;
  }
}

class Overlays {
  static const kPauseMenu = 'PauseMenu';
}
