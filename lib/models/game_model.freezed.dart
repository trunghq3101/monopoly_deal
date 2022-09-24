// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'game_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GameModel _$GameModelFromJson(Map<String, dynamic> json) {
  return _GameModel.fromJson(json);
}

/// @nodoc
mixin _$GameModel {
  PlayerModel? get turnOwner => throw _privateConstructorUsedError;
  List<PlayerModel> get players => throw _privateConstructorUsedError;
  Steps get step => throw _privateConstructorUsedError;
  List<MoveModel> get moves => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameModelCopyWith<GameModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameModelCopyWith<$Res> {
  factory $GameModelCopyWith(GameModel value, $Res Function(GameModel) then) =
      _$GameModelCopyWithImpl<$Res>;
  $Res call(
      {PlayerModel? turnOwner,
      List<PlayerModel> players,
      Steps step,
      List<MoveModel> moves});

  $PlayerModelCopyWith<$Res>? get turnOwner;
}

/// @nodoc
class _$GameModelCopyWithImpl<$Res> implements $GameModelCopyWith<$Res> {
  _$GameModelCopyWithImpl(this._value, this._then);

  final GameModel _value;
  // ignore: unused_field
  final $Res Function(GameModel) _then;

  @override
  $Res call({
    Object? turnOwner = freezed,
    Object? players = freezed,
    Object? step = freezed,
    Object? moves = freezed,
  }) {
    return _then(_value.copyWith(
      turnOwner: turnOwner == freezed
          ? _value.turnOwner
          : turnOwner // ignore: cast_nullable_to_non_nullable
              as PlayerModel?,
      players: players == freezed
          ? _value.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<PlayerModel>,
      step: step == freezed
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as Steps,
      moves: moves == freezed
          ? _value.moves
          : moves // ignore: cast_nullable_to_non_nullable
              as List<MoveModel>,
    ));
  }

  @override
  $PlayerModelCopyWith<$Res>? get turnOwner {
    if (_value.turnOwner == null) {
      return null;
    }

    return $PlayerModelCopyWith<$Res>(_value.turnOwner!, (value) {
      return _then(_value.copyWith(turnOwner: value));
    });
  }
}

/// @nodoc
abstract class _$$_GameModelCopyWith<$Res> implements $GameModelCopyWith<$Res> {
  factory _$$_GameModelCopyWith(
          _$_GameModel value, $Res Function(_$_GameModel) then) =
      __$$_GameModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {PlayerModel? turnOwner,
      List<PlayerModel> players,
      Steps step,
      List<MoveModel> moves});

  @override
  $PlayerModelCopyWith<$Res>? get turnOwner;
}

/// @nodoc
class __$$_GameModelCopyWithImpl<$Res> extends _$GameModelCopyWithImpl<$Res>
    implements _$$_GameModelCopyWith<$Res> {
  __$$_GameModelCopyWithImpl(
      _$_GameModel _value, $Res Function(_$_GameModel) _then)
      : super(_value, (v) => _then(v as _$_GameModel));

  @override
  _$_GameModel get _value => super._value as _$_GameModel;

  @override
  $Res call({
    Object? turnOwner = freezed,
    Object? players = freezed,
    Object? step = freezed,
    Object? moves = freezed,
  }) {
    return _then(_$_GameModel(
      turnOwner: turnOwner == freezed
          ? _value.turnOwner
          : turnOwner // ignore: cast_nullable_to_non_nullable
              as PlayerModel?,
      players: players == freezed
          ? _value._players
          : players // ignore: cast_nullable_to_non_nullable
              as List<PlayerModel>,
      step: step == freezed
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as Steps,
      moves: moves == freezed
          ? _value._moves
          : moves // ignore: cast_nullable_to_non_nullable
              as List<MoveModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GameModel extends _GameModel {
  _$_GameModel(
      {this.turnOwner,
      required final List<PlayerModel> players,
      required this.step,
      required final List<MoveModel> moves})
      : _players = players,
        _moves = moves,
        super._();

  factory _$_GameModel.fromJson(Map<String, dynamic> json) =>
      _$$_GameModelFromJson(json);

  @override
  final PlayerModel? turnOwner;
  final List<PlayerModel> _players;
  @override
  List<PlayerModel> get players {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  final Steps step;
  final List<MoveModel> _moves;
  @override
  List<MoveModel> get moves {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moves);
  }

  @override
  String toString() {
    return 'GameModel(turnOwner: $turnOwner, players: $players, step: $step, moves: $moves)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GameModel &&
            const DeepCollectionEquality().equals(other.turnOwner, turnOwner) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            const DeepCollectionEquality().equals(other.step, step) &&
            const DeepCollectionEquality().equals(other._moves, _moves));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(turnOwner),
      const DeepCollectionEquality().hash(_players),
      const DeepCollectionEquality().hash(step),
      const DeepCollectionEquality().hash(_moves));

  @JsonKey(ignore: true)
  @override
  _$$_GameModelCopyWith<_$_GameModel> get copyWith =>
      __$$_GameModelCopyWithImpl<_$_GameModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GameModelToJson(
      this,
    );
  }
}

abstract class _GameModel extends GameModel {
  factory _GameModel(
      {final PlayerModel? turnOwner,
      required final List<PlayerModel> players,
      required final Steps step,
      required final List<MoveModel> moves}) = _$_GameModel;
  _GameModel._() : super._();

  factory _GameModel.fromJson(Map<String, dynamic> json) =
      _$_GameModel.fromJson;

  @override
  PlayerModel? get turnOwner;
  @override
  List<PlayerModel> get players;
  @override
  Steps get step;
  @override
  List<MoveModel> get moves;
  @override
  @JsonKey(ignore: true)
  _$$_GameModelCopyWith<_$_GameModel> get copyWith =>
      throw _privateConstructorUsedError;
}
