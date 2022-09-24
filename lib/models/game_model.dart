import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monopoly_deal/models/moves/move_model.dart';
import 'package:monopoly_deal/models/player_model.dart';
import 'package:monopoly_deal/repositories/game_repository.dart';

part 'game_model.freezed.dart';
part 'game_model.g.dart';

enum Steps { idle, draw, play, drop }

enum GameState { waiting, ready }

@freezed
class GameModel with _$GameModel {
  const GameModel._();

  factory GameModel({
    PlayerModel? turnOwner,
    required List<PlayerModel> players,
    required Steps step,
    required List<MoveModel> moves,
  }) = _GameModel;

  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);
}

extension GameModelMethods on GameModel {
  Future<void> addPlayer(PlayerModel player, GameRepository repository) async {
    // if (_playerJoined) throw Exception('Already joined this game');
    // await repository.addPlayer(player);
    // _playerJoined = true;
  }

  Future<void> syncUp() async {
    // players = await _gameRepository.fetchPlayers();
    // if (players.length > 1) {
    //   turnOwner = await _gameRepository.fetchTurnOwner();
    //   gameState = GameState.ready;
    //   return;
    // }
    // gameState = GameState.waiting;
  }

  // Steps nextStep() {
  //   // step = Steps.values[(step.index + 1) % Steps.values.length];
  //   // return step;
  // }
}
