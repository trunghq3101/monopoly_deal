import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/models/card.dart';
import 'package:monopoly_deal/models/game_round.dart';
import 'package:monopoly_deal/models/player.dart';
import 'package:monopoly_deal/repositories/game_repository.dart';

import 'game_machine.dart';

abstract class GameMove {
  GameMove({required this.player});

  final Player player;
  void move();
}

class DrawMove extends GameMove {
  DrawMove({
    required super.player,
    required this.amount,
  });

  final int amount;

  @override
  void move() {}
}

class PutMove extends GameMove {
  PutMove({
    required super.player,
    required this.card,
  });

  final Card card;

  @override
  void move() {}
}

class EndMove extends GameMove {
  EndMove({
    required super.player,
  });

  @override
  void move() {}
}

enum GameState { waiting, ready }

class TestGameRepository extends GameRepository {}

void main() {
  test('Go through the game', () {
    final game = GameRound(repository: TestGameRepository());
    final gameMachine = GameMachine(game: game);
    final player = Player(game: game);
    final machinePlayer = GameMachine.newPlayer(game: game);
    GameMove lastMove;
    game.addPlayer(player);
    expect(game.fetchState(), GameState.waiting);
    gameMachine.addPlayer(machinePlayer);
    expect(game.fetchState(), GameState.ready);
    expect(game.players.length, 2);
    expect(game.cardDeck, CardDeck());
    expect(player.hand.length, 5);
    expect(game.fetchTurnOwner(), player);
    expect(
      game.nextStep(),
      Steps.draw,
    );
    lastMove = DrawMove(player: player, amount: 2);
    lastMove.move();
    expect(player.hand.length, 7);
    expect(game.fetchLastMove(), lastMove);
    expect(
      game.nextStep(),
      Steps.play,
    );
    lastMove = PutMove(player: player, card: Card('1'));
    expect(player.hand.length, 6);
    expect(game.fetchLastMove(), lastMove);
    lastMove = PutMove(player: player, card: Card('2'));
    expect(player.hand.length, 5);
    expect(game.fetchLastMove(), lastMove);
    lastMove = PutMove(player: player, card: Card('3'));
    expect(player.hand.length, 4);
    expect(game.fetchLastMove(), lastMove);
    lastMove = EndMove(player: player);
    expect(
      game.nextStep(),
      Steps.idle,
    );
    expect(game.fetchTurnOwner(), machinePlayer);

    gameMachine.nextStep();
    expect(
      game.nextStep(),
      Steps.draw,
    );
    lastMove = DrawMove(player: machinePlayer, amount: 2);
    lastMove.move();
    expect(machinePlayer.hand.length, 7);
    expect(game.fetchLastMove(), lastMove);
    expect(
      game.nextStep(),
      Steps.play,
    );
    lastMove = PutMove(player: machinePlayer, card: Card('1'));
    expect(machinePlayer.hand.length, 6);
    expect(game.fetchLastMove(), lastMove);
    lastMove = PutMove(player: machinePlayer, card: Card('2'));
    expect(machinePlayer.hand.length, 5);
    expect(game.fetchLastMove(), lastMove);
    lastMove = PutMove(player: machinePlayer, card: Card('3'));
    expect(machinePlayer.hand.length, 4);
    expect(game.fetchLastMove(), lastMove);
    lastMove = EndMove(player: machinePlayer);
    expect(
      game.nextStep(),
      Steps.idle,
    );
    expect(game.fetchTurnOwner(), player);
  }, skip: true);
}
