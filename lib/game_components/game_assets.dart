import 'package:flame/flame.dart';
import 'package:rive/rive.dart';

final gameAssets = GameAssets();

class GameAssets {
  int? Function() randomSeed = () => null;
  final Map<String, RiveFile> _riveFiles = {};

  Future<void> preCache() async {
    _riveFiles['buttons'] = await RiveFile.asset('assets/images/buttons.riv');
    await Flame.images.load('card.png');
  }

  RiveFile riveFile(String name) => _riveFiles[name]!;
}

class Overlays {
  static const kPauseMenu = 'PauseMenu';
}
