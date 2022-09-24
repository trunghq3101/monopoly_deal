// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GameModel _$$_GameModelFromJson(Map<String, dynamic> json) => _$_GameModel(
      turnOwner: json['turnOwner'] == null
          ? null
          : PlayerModel.fromJson(json['turnOwner'] as Map<String, dynamic>),
      players: (json['players'] as List<dynamic>)
          .map((e) => PlayerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      step: $enumDecode(_$StepsEnumMap, json['step']),
      moves: (json['moves'] as List<dynamic>)
          .map((e) => MoveModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_GameModelToJson(_$_GameModel instance) =>
    <String, dynamic>{
      'turnOwner': instance.turnOwner,
      'players': instance.players,
      'step': _$StepsEnumMap[instance.step]!,
      'moves': instance.moves,
    };

const _$StepsEnumMap = {
  Steps.idle: 'idle',
  Steps.draw: 'draw',
  Steps.play: 'play',
  Steps.drop: 'drop',
};
