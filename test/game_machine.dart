import 'package:monopoly_deal/models/game_round.dart';

class GameMachine extends GameRound {
  final GameRound game;

  GameMachine({required this.game});

  static newPlayer({required GameRound game}) {}
}
