import '../player.dart';

abstract class GameMove {
  GameMove({required this.player});

  final Player player;
  void move();
}
