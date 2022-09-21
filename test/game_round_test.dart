import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/models/game_round.dart';
import 'package:monopoly_deal/models/player.dart';
import 'package:monopoly_deal/repositories/game_repository.dart';

import 'game_machine.dart';
import 'utils.dart';

void main() {
  group('GameRound test', () {
    late GameRound game;
    late GameMachine gameMachine;
    late GameRepository repository;
    late Player player;
    late Player machinePlayer;

    setUp(() {
      repository = TestGameRepository();
      game = GameRound(repository: repository);
      gameMachine = GameMachine(game: game, repository: repository);
      player = Player();
      machinePlayer = GameMachine.newPlayer();
    });

    test('Show game state based on number of players', () async {
      expect(await game.fetchState(), GameState.waiting);
      await game.addPlayer(player);
      expect(await game.fetchState(), GameState.waiting);
      await gameMachine.addPlayer(machinePlayer);
      expect(await game.fetchState(), GameState.ready);
    });

    test('Can only add 1 player to a game instance', () async {
      await game.addPlayer(player);
      expect(
        () async => await game.addPlayer(player),
        throwsException,
      );
    });

    test('Sync players when fetchState', () async {
      expect(game.players, []);
      await gameMachine.addPlayer(player);
      await game.fetchState();
      expect(game.players, [player]);
    });

    test('Sync turnOwner when game ready', () async {
      expect(game.players, []);
      await game.addPlayer(player);
      await gameMachine.addPlayer(Player());
      await game.fetchState();
      expect(game.turnOwner, player);
    });
  });
}
