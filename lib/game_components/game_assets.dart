import 'package:rive/rive.dart';

final gameAssets = GameAssets();

class GameAssets {
  final Map<String, RiveFile> _riveFiles = {};

  Future<void> load() async {
    _riveFiles['buttons'] = await RiveFile.asset('assets/images/buttons.riv');
  }

  RiveFile riveFile(String name) => _riveFiles[name]!;
}

class Overlays {
  static const kPauseMenu = 'PauseMenu';
}
