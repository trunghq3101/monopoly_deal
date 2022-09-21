import 'package:monopoly_deal/models/game_round.dart';
import 'package:monopoly_deal/models/player.dart';

class GameMachine extends GameRound {
  final GameRound game;

  GameMachine({
    required this.game,
    required super.repository,
  });

  static Player newPlayer() => Player();
}
