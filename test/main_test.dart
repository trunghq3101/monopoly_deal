import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/dev/repositories.dart';
import 'package:monopoly_deal/models/card_model.dart';
import 'package:monopoly_deal/models/game_model.dart';
import 'package:monopoly_deal/models/moves/move_model.dart';
import 'package:monopoly_deal/models/player_model.dart';

void main() {
  test('Go through the game', () async {
    final repository = TestGameRepository();
    var game = GameModel(moves: [], players: [], step: Steps.idle);
    var gameMachine = GameModel(moves: [], players: [], step: Steps.idle);
    var player = PlayerModel(hand: []);
    var machinePlayer = PlayerModel(hand: []);
    final cards = List.generate(15, (index) => CardModel(name: '$index'));
    List<MoveModel> moves = [];

    game = await game.addPlayer(player, repository);
    expect(game, GameModel(players: [player], step: Steps.idle, moves: []));
    gameMachine = await gameMachine.syncUp(repository);
    expect(gameMachine, game);

    gameMachine = await gameMachine.addPlayer(machinePlayer, repository);
    game = await game.syncUp(repository);
    final playerDealCards = [
      cards[14],
      cards[12],
      cards[10],
      cards[8],
      cards[6]
    ];
    moves.add(DealMove(player: player, cards: playerDealCards));
    player = PlayerModel(hand: playerDealCards);
    expect(
      game,
      GameModel(
        players: [player, machinePlayer],
        step: Steps.idle,
        moves: moves,
      ),
    );
    expect(game.gameState, GameState.ready);

    // await gameMachine.syncUp();
    // final machineDealCards = [
    //   cards[13],
    //   cards[11],
    //   cards[9],
    //   cards[7],
    //   cards[5]
    // ];
    // expect(
    //   gameMachine.moves.last,
    //   DealMove(player: machinePlayer, cards: machineDealCards),
    // );
    // expect(
    //   machinePlayer.hand,
    //   machineDealCards,
    // );
    // expect(game.turnOwner, player);
    // expect(game.step, Steps.idle);
    // expect(
    //   game.nextStep(),
    //   Steps.draw,
    // );
    // lastMove = DrawMove(player: player, deck: deck, amount: 2);
    // lastMove.move();
    // expect(
    //   player.hand,
    //   [cards[14], cards[12], cards[10], cards[8], cards[6], cards[4], cards[3]],
    // );
    // // expect(game.fetchLastMove(), lastMove);
    // expect(
    //   game.nextStep(),
    //   Steps.play,
    // );
    // lastMove = PutMove(player: player, card: cards[14]);
    // lastMove.move();
    // expect(player.hand,
    //     [cards[12], cards[10], cards[8], cards[6], cards[4], cards[3]]);
    // // expect(game.fetchLastMove(), lastMove);
    // lastMove = PutMove(player: player, card: cards[12]);
    // lastMove.move();
    // expect(player.hand, [cards[10], cards[8], cards[6], cards[4], cards[3]]);
    // // expect(game.fetchLastMove(), lastMove);
    // lastMove = PutMove(player: player, card: cards[10]);
    // lastMove.move();
    // expect(player.hand, [cards[8], cards[6], cards[4], cards[3]]);
    // // expect(game.fetchLastMove(), lastMove);
    // lastMove = EndMove(player: player);
    // expect(
    //   game.nextStep(),
    //   Steps.idle,
    // );
    // expect(game.turnOwner, machinePlayer);

    // gameMachine.nextStep();
    // expect(
    //   game.nextStep(),
    //   Steps.draw,
    // );
    // lastMove = DrawMove(player: machinePlayer, deck: deck, amount: 2);
    // lastMove.move();
    // expect(machinePlayer.hand.length, 7);
    // expect(game.syncUp(), lastMove);
    // expect(
    //   game.nextStep(),
    //   Steps.play,
    // );
    // lastMove = PutMove(player: machinePlayer, card: Card('1'));
    // expect(machinePlayer.hand.length, 6);
    // expect(game.syncUp(), lastMove);
    // lastMove = PutMove(player: machinePlayer, card: Card('2'));
    // expect(machinePlayer.hand.length, 5);
    // expect(game.syncUp(), lastMove);
    // lastMove = PutMove(player: machinePlayer, card: Card('3'));
    // expect(machinePlayer.hand.length, 4);
    // expect(game.syncUp(), lastMove);
    // lastMove = EndMove(player: machinePlayer);
    // expect(
    //   game.nextStep(),
    //   Steps.idle,
    // );
    // expect(game.turnOwner, player);
  }, skip: true);
}
