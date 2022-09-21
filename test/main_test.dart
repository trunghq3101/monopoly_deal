import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/models/card.dart';
import 'package:monopoly_deal/models/game_round.dart';
import 'package:monopoly_deal/models/moves/deal_move.dart';
import 'package:monopoly_deal/models/moves/draw_move.dart';
import 'package:monopoly_deal/models/moves/end_move.dart';
import 'package:monopoly_deal/models/moves/move.dart';
import 'package:monopoly_deal/models/moves/put_move.dart';
import 'package:monopoly_deal/models/player.dart';

import 'game_machine.dart';
import 'utils.dart';

void main() {
  test('Go through the game', () async {
    final repository = TestGameRepository();
    final game = GameRound(repository: repository);
    final gameMachine = GameMachine(game: game, repository: repository);
    final dealer = Player();
    final player = Player();
    final machinePlayer = GameMachine.newPlayer();
    final deck = CardDeck(initial: []);
    GameMove lastMove;
    await game.addPlayer(player);
    expect(await game.fetchState(), GameState.waiting);
    await gameMachine.addPlayer(machinePlayer);
    expect(await game.fetchState(), GameState.ready);
    expect(game.players.length, 2);
    lastMove = DealMove(player: dealer, deck: deck, players: game.players);
    lastMove.move();
    expect(player.hand.length, 5);
    expect(machinePlayer.hand.length, 5);
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
