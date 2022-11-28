import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:rive/rive.dart';

final gameAssets = GameAssets();

const kOverlayPriority0 = 99999;
const kOverlayPriority1 = 99998;

Vector2 playgroundSize = Vector2.zero();

class GameAssets {
  int? Function() randomSeed = () => null;
  final Map<String, RiveFile> _riveFiles = {};
  List<Sprite> cardSprites = [];
  Map<String, Vector2> cardPositions = {};
  Map<String, Sprite> sprites = {};

  Future<void> preCache() async {
    _riveFiles['buttons'] = await RiveFile.asset('assets/images/buttons.riv');
    sprites['card'] = Sprite(await Flame.images.load('card.png'));
    for (var i = 1; i < 10; i++) {
      await Flame.images.load('0$i.png');
    }
    for (var i = 10; i < 41; i++) {
      await Flame.images.load('$i.png');
    }
    cardSprites =
        '''01,01,02,02,03,03,03,04,04,04,05,05,05,06,06,06,07,07,07,07,08,08,08,09,09,10,10,10,
        11,11,12,12,12,13,13,14,14,14,14,15,15,15,16,16,16,17,17,17,18,18,18,19,19,19,
        40,40,40,40,40,40,40,40,40,40,
        20,21,22,22,23,24,25,26,26,27,27,
        28,28,29,29,30,30,31,31,32,32,33,33,33,
        34,34,34,34,34,34,
        35,35,35,35,35,
        36,36,36,37,37,37,38,38,39'''
            .split(',')
            .map((e) => Sprite(Flame.images.fromCache('${e.trim()}.png')))
            .toList();
    cardPositions = {
      '01': Vector2(-1000, 1000),
      '02': Vector2(-300, 1000),
    };
  }

  RiveFile riveFile(String name) => _riveFiles[name]!;
}

class Overlays {
  static const kPauseMenu = 'PauseMenu';
}
