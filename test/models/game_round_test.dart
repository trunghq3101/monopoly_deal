import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/dev/repositories.dart';
import 'package:monopoly_deal/models/player.dart';
import 'package:monopoly_deal/repositories/game_repository.dart';

void main() {
  // group('GameRound test', () {
  //   late GameRound game;
  //   late GameRound gameMachine;
  //   late GameRepository repository;
  //   late Player player;
  //   late Player machinePlayer;

  //   setUp(() {
  //     repository = TestGameRepository();
  //     game = GameRound(repository: repository);
  //     gameMachine = GameRound(repository: repository);
  //     player = Player();
  //     machinePlayer = Player();
  //   });

  //   test('Show game state based on number of players', () async {
  //     await game.syncUp();
  //     expect(game.gameState, GameState.waiting);
  //     await game.addPlayer(player);
  //     await game.syncUp();
  //     expect(game.gameState, GameState.waiting);
  //     await gameMachine.addPlayer(machinePlayer);
  //     await game.syncUp();
  //     expect(game.gameState, GameState.ready);
  //   });

  //   test('Can only add 1 player to a game instance', () async {
  //     await game.addPlayer(player);
  //     expect(
  //       () async => await game.addPlayer(player),
  //       throwsException,
  //     );
  //   });

  //   test('syncUp', () async {
  //     final machinePlayer = Player();
  //     expect(game.players, []);
  //     await game.addPlayer(player);
  //     await game.syncUp();
  //     expect(game.players, [player]);
  //     expect(gameMachine.players, []);
  //     await gameMachine.syncUp();
  //     expect(gameMachine.players, [player]);
  //     await gameMachine.addPlayer(machinePlayer);
  //     await gameMachine.syncUp();
  //     expect(gameMachine.players, [player, machinePlayer]);
  //     expect(game.players, [player]);
  //     await game.syncUp();
  //     expect(game.players, [player, machinePlayer]);
  //     expect(game.turnOwner, player);
  //   });

  //   test('Change steps', () {
  //     expect(game.step, Steps.idle);
  //     expect(game.nextStep(), Steps.draw);
  //     expect(game.nextStep(), Steps.play);
  //     expect(game.nextStep(), Steps.drop);
  //     expect(game.nextStep(), Steps.idle);
  //   });
  // });
}
