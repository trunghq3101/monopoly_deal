import 'package:freezed_annotation/freezed_annotation.dart';

import 'card_model.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart';

@freezed
class PlayerModel with _$PlayerModel {
  factory PlayerModel({
    required List<CardModel> hand,
  }) = _PlayerModel;

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);
}
