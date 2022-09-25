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
  GameState get gameState =>
      players.length > 1 ? GameState.ready : GameState.waiting;

  Future<GameModel> addPlayer(
    PlayerModel player,
    GameRepository repository,
  ) async {
    await repository.addPlayer(player);
    return repository.gameModel;
  }

  Future<GameModel> syncUp(GameRepository repository) async {
    return repository.gameModel;
  }

  // Steps nextStep() {
  //   // step = Steps.values[(step.index + 1) % Steps.values.length];
  //   // return step;
  // }
}
