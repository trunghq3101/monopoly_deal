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

    setUp(() {
      repository = TestGameRepository();
      game = GameRound(repository: repository);
      gameMachine = GameMachine(game: game, repository: repository);
    });

    test('Must have at least 2 players to start', () {
      expect(game.started, false);
      expect(() => game.start(), throwsAssertionError);
      game.addPlayer(Player(game: game));
      expect(() => game.start(), throwsAssertionError);
      game.addPlayer(Player(game: game));
      game.start();
      expect(game.started, true);
    });

    test('Show game state based on number of players', () async {
      final machinePlayer = GameMachine.newPlayer(game: game);
      expect(await game.fetchState(), GameState.waiting);
      await game.addPlayer(Player(game: game));
      expect(await game.fetchState(), GameState.waiting);
      await gameMachine.addPlayer(machinePlayer);
      expect(await game.fetchState(), GameState.ready);
    });

    test('Can only add 1 player to a game instance', () async {
      await game.addPlayer(Player(game: game));
      expect(
        () async => await game.addPlayer(Player(game: game)),
        throwsException,
      );
    });
  });
}
