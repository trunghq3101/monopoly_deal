import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/dev/repositories.dart';
import 'package:monopoly_deal/models/card.dart';
import 'package:monopoly_deal/models/game_round.dart';
import 'package:monopoly_deal/models/moves/deal_move.dart';
import 'package:monopoly_deal/models/moves/draw_move.dart';
import 'package:monopoly_deal/models/moves/end_move.dart';
import 'package:monopoly_deal/models/moves/move.dart';
import 'package:monopoly_deal/models/moves/put_move.dart';
import 'package:monopoly_deal/models/player.dart';

void main() {
  test('Go through the game', () async {
    final repository = TestGameRepository();
    final game = GameRound(repository: repository);
    final gameMachine = GameRound(repository: repository);
    final dealer = Player();
    final player = Player();
    final machinePlayer = Player();
    final cards = List.generate(15, (index) => Card('$index'));
    final deck = CardDeck(initial: cards);
    GameMove lastMove;
    await game.addPlayer(player);
    expect(await game.fetchState(), GameState.waiting);
    await gameMachine.addPlayer(machinePlayer);
    expect(await game.fetchState(), GameState.ready);
    expect(game.players.length, 2);
    lastMove = DealMove(player: dealer, deck: deck, players: game.players);
    lastMove.move();
    expect(
      player.hand,
      [cards[14], cards[12], cards[10], cards[8], cards[6]],
    );
    expect(
      machinePlayer.hand,
      [cards[13], cards[11], cards[9], cards[7], cards[5]],
    );
    expect(game.turnOwner, player);
    expect(game.step, Steps.idle);
    expect(
      game.nextStep(),
      Steps.draw,
    );
    lastMove = DrawMove(player: player, deck: deck, amount: 2);
    lastMove.move();
    expect(
      player.hand,
      [cards[14], cards[12], cards[10], cards[8], cards[6], cards[4], cards[3]],
    );
    // expect(game.fetchLastMove(), lastMove);
    expect(
      game.nextStep(),
      Steps.play,
    );
    lastMove = PutMove(player: player, card: cards[14]);
    lastMove.move();
    expect(player.hand,
        [cards[12], cards[10], cards[8], cards[6], cards[4], cards[3]]);
    // expect(game.fetchLastMove(), lastMove);
    lastMove = PutMove(player: player, card: cards[12]);
    lastMove.move();
    expect(player.hand, [cards[10], cards[8], cards[6], cards[4], cards[3]]);
    // expect(game.fetchLastMove(), lastMove);
    lastMove = PutMove(player: player, card: cards[10]);
    lastMove.move();
    expect(player.hand, [cards[8], cards[6], cards[4], cards[3]]);
    // expect(game.fetchLastMove(), lastMove);
    lastMove = EndMove(player: player);
    expect(
      game.nextStep(),
      Steps.idle,
    );
    expect(game.turnOwner, machinePlayer);

    gameMachine.nextStep();
    expect(
      game.nextStep(),
      Steps.draw,
    );
    lastMove = DrawMove(player: machinePlayer, deck: deck, amount: 2);
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
    expect(game.turnOwner, player);
  }, skip: true);
}
