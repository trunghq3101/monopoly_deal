import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:rive/rive.dart';

final gameAssets = GameAssets();

class GameAssets {
  int? Function() randomSeed = () => null;
  final Map<String, RiveFile> _riveFiles = {};
  List<Sprite> cardSprites = [];
  Map<String, Vector2> cardPositionsBySpriteName = {};
  Map<String, Sprite> sprites = {};
  List<String> cardSpriteNames = [];

  Future<void> preCache() async {
    _riveFiles['buttons'] = await RiveFile.asset('assets/images/buttons.riv');
    sprites['card'] = Sprite(await Flame.images.load('card.png'));
    for (var i = 1; i < 10; i++) {
      await Flame.images.load('0$i.png');
    }
    for (var i = 10; i < 41; i++) {
      await Flame.images.load('$i.png');
    }
    cardSpriteNames =
        '''01,01,02,02,03,03,03,04,04,04,05,05,05,06,06,06,07,07,07,07,08,08,08,09,09,10,10,10,
        11,11,12,12,12,13,13,14,14,14,14,15,15,15,16,16,16,17,17,17,18,18,18,19,19,19,
        40,40,40,40,40,40,40,40,40,40,
        20,21,22,22,23,24,25,26,26,27,27,
        28,28,29,29,30,30,31,31,32,32,33,33,33,
        34,34,34,34,34,34,
        35,35,35,35,35,
        36,36,36,37,37,37,38,38,39'''
            .split(',');
    cardSprites = cardSpriteNames
        .map((name) => Sprite(Flame.images.fromCache('${name.trim()}.png')))
        .toList();
    final columns = [
      Vector2(-700, 0),
      Vector2(-350, 0),
      Vector2(0, 0),
      Vector2(350, 0),
      Vector2(700, 0),
    ];
    final rowSpacing = Vector2(0, 500);
    final actionCardPosition = Vector2(500, 0);
    final bankPosition = rowSpacing * 3;
    cardPositionsBySpriteName = {
      '01': columns[0] + rowSpacing,
      '02': columns[1] + rowSpacing,
      '03': columns[2] + rowSpacing,
      '04': columns[3] + rowSpacing,
      '05': columns[4] + rowSpacing,
      '06': columns[0] + rowSpacing * 2,
      '07': columns[1] + rowSpacing * 2,
      '08': columns[2] + rowSpacing * 2,
      '09': columns[3] + rowSpacing * 2,
      '10': columns[4] + rowSpacing * 2,
      '11': actionCardPosition,
      '12': actionCardPosition,
      '13': actionCardPosition,
      '14': actionCardPosition,
      '15': actionCardPosition,
      '16': actionCardPosition,
      '17': actionCardPosition,
      '18': actionCardPosition,
      '19': actionCardPosition,
      '28': actionCardPosition,
      '29': actionCardPosition,
      '30': actionCardPosition,
      '31': actionCardPosition,
      '32': actionCardPosition,
      '33': actionCardPosition,
      '40': actionCardPosition,
      '34': bankPosition,
      '35': bankPosition,
      '36': bankPosition,
      '37': bankPosition,
      '38': bankPosition,
      '39': bankPosition,
    };
  }

  RiveFile riveFile(String name) => _riveFiles[name]!;
}

class Overlays {
  static const kPauseMenu = 'PauseMenu';
}
