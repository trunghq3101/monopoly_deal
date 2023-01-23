import 'dart:async';
import 'dart:ui';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/game/game.dart';

class MainGame extends FlameGame
    with HasHoverableComponents, HasTappableComponents {
  MainGame({this.isFake = false, RoomGateway? roomGateway})
      : _roomGateway = roomGateway ?? RoomGateway();

  static GameMap gameMap = GameMap();
  static GameAsset gameAsset = GameAsset();
  static var cardTotalAmount = 100;

  final bool isFake;
  final RoomGateway _roomGateway;

  @override
  backgroundColor() => const Color.fromARGB(255, 192, 50, 50);

  @override
  Future<void>? onLoad() async {
    await gameAsset.load();

    gameMap = GameMap(
        myIndex: isFake ? 0 : _roomGateway.myIndex,
        deckCenter: Vector2(0, 700),
        deckSpacing: 0.7,
        cardSize: Vector2(300, 440),
        playerPositions: [
          Vector2(0, 1400),
          ...List.generate(
              (_roomGateway.playerAmount ?? 2) - 1,
              (index) => Vector2(
                  (3000 / (_roomGateway.playerAmount ?? 2)) * (index + 1) -
                      3000 * 0.5,
                  -500))
        ]);

    add(RouterComponent(
      initialRoute: '/',
      routes: {
        '/': Route(() => GamePage(isFake: isFake, roomGateway: _roomGateway)),
      },
    ));
  }
}
