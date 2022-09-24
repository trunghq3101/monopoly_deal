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
  return _MoveModel.fromJson(json);
}

/// @nodoc
mixin _$MoveModel {
  PlayerModel get player => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MoveModelCopyWith<MoveModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoveModelCopyWith<$Res> {
  factory $MoveModelCopyWith(MoveModel value, $Res Function(MoveModel) then) =
      _$MoveModelCopyWithImpl<$Res>;
  $Res call({PlayerModel player});

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
  }) {
    return _then(_value.copyWith(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as PlayerModel,
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
abstract class _$$_MoveModelCopyWith<$Res> implements $MoveModelCopyWith<$Res> {
  factory _$$_MoveModelCopyWith(
          _$_MoveModel value, $Res Function(_$_MoveModel) then) =
      __$$_MoveModelCopyWithImpl<$Res>;
  @override
  $Res call({PlayerModel player});

  @override
  $PlayerModelCopyWith<$Res> get player;
}

/// @nodoc
class __$$_MoveModelCopyWithImpl<$Res> extends _$MoveModelCopyWithImpl<$Res>
    implements _$$_MoveModelCopyWith<$Res> {
  __$$_MoveModelCopyWithImpl(
      _$_MoveModel _value, $Res Function(_$_MoveModel) _then)
      : super(_value, (v) => _then(v as _$_MoveModel));

  @override
  _$_MoveModel get _value => super._value as _$_MoveModel;

  @override
  $Res call({
    Object? player = freezed,
  }) {
    return _then(_$_MoveModel(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as PlayerModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MoveModel implements _MoveModel {
  _$_MoveModel({required this.player});

  factory _$_MoveModel.fromJson(Map<String, dynamic> json) =>
      _$$_MoveModelFromJson(json);

  @override
  final PlayerModel player;

  @override
  String toString() {
    return 'MoveModel(player: $player)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MoveModel &&
            const DeepCollectionEquality().equals(other.player, player));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(player));

  @JsonKey(ignore: true)
  @override
  _$$_MoveModelCopyWith<_$_MoveModel> get copyWith =>
      __$$_MoveModelCopyWithImpl<_$_MoveModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MoveModelToJson(
      this,
    );
  }
}

abstract class _MoveModel implements MoveModel {
  factory _MoveModel({required final PlayerModel player}) = _$_MoveModel;

  factory _MoveModel.fromJson(Map<String, dynamic> json) =
      _$_MoveModel.fromJson;

  @override
  PlayerModel get player;
  @override
  @JsonKey(ignore: true)
  _$$_MoveModelCopyWith<_$_MoveModel> get copyWith =>
      throw _privateConstructorUsedError;
}
