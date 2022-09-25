// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'move_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MoveModel _$MoveModelFromJson(Map<String, dynamic> json) {
  return DealMove.fromJson(json);
}

/// @nodoc
mixin _$MoveModel {
  PlayerModel get player => throw _privateConstructorUsedError;
  List<CardModel> get cards => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PlayerModel player, List<CardModel> cards)
        dealMove,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(PlayerModel player, List<CardModel> cards)? dealMove,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PlayerModel player, List<CardModel> cards)? dealMove,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DealMove value) dealMove,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DealMove value)? dealMove,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DealMove value)? dealMove,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MoveModelCopyWith<MoveModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoveModelCopyWith<$Res> {
  factory $MoveModelCopyWith(MoveModel value, $Res Function(MoveModel) then) =
      _$MoveModelCopyWithImpl<$Res>;
  $Res call({PlayerModel player, List<CardModel> cards});

  $PlayerModelCopyWith<$Res> get player;
}

/// @nodoc
class _$MoveModelCopyWithImpl<$Res> implements $MoveModelCopyWith<$Res> {
  _$MoveModelCopyWithImpl(this._value, this._then);

  final MoveModel _value;
  // ignore: unused_field
  final $Res Function(MoveModel) _then;

  @override
  $Res call({
    Object? player = freezed,
    Object? cards = freezed,
  }) {
    return _then(_value.copyWith(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as PlayerModel,
      cards: cards == freezed
          ? _value.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<CardModel>,
    ));
  }

  @override
  $PlayerModelCopyWith<$Res> get player {
    return $PlayerModelCopyWith<$Res>(_value.player, (value) {
      return _then(_value.copyWith(player: value));
    });
  }
}

/// @nodoc
abstract class _$$DealMoveCopyWith<$Res> implements $MoveModelCopyWith<$Res> {
  factory _$$DealMoveCopyWith(
          _$DealMove value, $Res Function(_$DealMove) then) =
      __$$DealMoveCopyWithImpl<$Res>;
  @override
  $Res call({PlayerModel player, List<CardModel> cards});

  @override
  $PlayerModelCopyWith<$Res> get player;
}

/// @nodoc
class __$$DealMoveCopyWithImpl<$Res> extends _$MoveModelCopyWithImpl<$Res>
    implements _$$DealMoveCopyWith<$Res> {
  __$$DealMoveCopyWithImpl(_$DealMove _value, $Res Function(_$DealMove) _then)
      : super(_value, (v) => _then(v as _$DealMove));

  @override
  _$DealMove get _value => super._value as _$DealMove;

  @override
  $Res call({
    Object? player = freezed,
    Object? cards = freezed,
  }) {
    return _then(_$DealMove(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as PlayerModel,
      cards: cards == freezed
          ? _value._cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<CardModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DealMove implements DealMove {
  _$DealMove({required this.player, required final List<CardModel> cards})
      : _cards = cards;

  factory _$DealMove.fromJson(Map<String, dynamic> json) =>
      _$$DealMoveFromJson(json);

  @override
  final PlayerModel player;
  final List<CardModel> _cards;
  @override
  List<CardModel> get cards {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cards);
  }

  @override
  String toString() {
    return 'MoveModel.dealMove(player: $player, cards: $cards)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DealMove &&
            const DeepCollectionEquality().equals(other.player, player) &&
            const DeepCollectionEquality().equals(other._cards, _cards));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(player),
      const DeepCollectionEquality().hash(_cards));

  @JsonKey(ignore: true)
  @override
  _$$DealMoveCopyWith<_$DealMove> get copyWith =>
      __$$DealMoveCopyWithImpl<_$DealMove>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PlayerModel player, List<CardModel> cards)
        dealMove,
  }) {
    return dealMove(player, cards);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(PlayerModel player, List<CardModel> cards)? dealMove,
  }) {
    return dealMove?.call(player, cards);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PlayerModel player, List<CardModel> cards)? dealMove,
    required TResult orElse(),
  }) {
    if (dealMove != null) {
      return dealMove(player, cards);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DealMove value) dealMove,
  }) {
    return dealMove(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DealMove value)? dealMove,
  }) {
    return dealMove?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DealMove value)? dealMove,
    required TResult orElse(),
  }) {
    if (dealMove != null) {
      return dealMove(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DealMoveToJson(
      this,
    );
  }
}

abstract class DealMove implements MoveModel {
  factory DealMove(
      {required final PlayerModel player,
      required final List<CardModel> cards}) = _$DealMove;

  factory DealMove.fromJson(Map<String, dynamic> json) = _$DealMove.fromJson;

  @override
  PlayerModel get player;
  @override
  List<CardModel> get cards;
  @override
  @JsonKey(ignore: true)
  _$$DealMoveCopyWith<_$DealMove> get copyWith =>
      throw _privateConstructorUsedError;
}
