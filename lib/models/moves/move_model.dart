import 'package:freezed_annotation/freezed_annotation.dart';

import '../player_model.dart';

part 'move_model.freezed.dart';
part 'move_model.g.dart';

@freezed
abstract class MoveModel with _$MoveModel {
  factory MoveModel({required PlayerModel player}) = _MoveModel;

  factory MoveModel.fromJson(Map<String, dynamic> json) =>
      _$MoveModelFromJson(json);
}
