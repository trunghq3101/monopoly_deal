// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DealMove _$$DealMoveFromJson(Map<String, dynamic> json) => _$DealMove(
      player: PlayerModel.fromJson(json['player'] as Map<String, dynamic>),
      cards: (json['cards'] as List<dynamic>)
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DealMoveToJson(_$DealMove instance) =>
    <String, dynamic>{
      'player': instance.player,
      'cards': instance.cards,
    };
