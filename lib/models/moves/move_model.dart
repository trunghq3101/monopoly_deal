import 'package:freezed_annotation/freezed_annotation.dart';

import '../card_model.dart';
import '../player_model.dart';

part 'move_model.freezed.dart';
part 'move_model.g.dart';

@freezed
class MoveModel with _$MoveModel {
  factory MoveModel.dealMove({
    required PlayerModel player,
    required List<CardModel> cards,
  }) = DealMove;

  factory MoveModel.fromJson(Map<String, dynamic> json) =>
      _$MoveModelFromJson(json);
}
