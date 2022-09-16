// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'purchase_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PurchaseState {
  Offerings? get offerings => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PurchaseStateCopyWith<PurchaseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseStateCopyWith<$Res> {
  factory $PurchaseStateCopyWith(
          PurchaseState value, $Res Function(PurchaseState) then) =
      _$PurchaseStateCopyWithImpl<$Res>;
  $Res call({Offerings? offerings});
}

/// @nodoc
class _$PurchaseStateCopyWithImpl<$Res>
    implements $PurchaseStateCopyWith<$Res> {
  _$PurchaseStateCopyWithImpl(this._value, this._then);

  final PurchaseState _value;
  // ignore: unused_field
  final $Res Function(PurchaseState) _then;

  @override
  $Res call({
    Object? offerings = freezed,
  }) {
    return _then(_value.copyWith(
      offerings: offerings == freezed
          ? _value.offerings
          : offerings // ignore: cast_nullable_to_non_nullable
              as Offerings?,
    ));
  }
}

/// @nodoc
abstract class _$$_PurchaseStateCopyWith<$Res>
    implements $PurchaseStateCopyWith<$Res> {
  factory _$$_PurchaseStateCopyWith(
          _$_PurchaseState value, $Res Function(_$_PurchaseState) then) =
      __$$_PurchaseStateCopyWithImpl<$Res>;
  @override
  $Res call({Offerings? offerings});
}

/// @nodoc
class __$$_PurchaseStateCopyWithImpl<$Res>
    extends _$PurchaseStateCopyWithImpl<$Res>
    implements _$$_PurchaseStateCopyWith<$Res> {
  __$$_PurchaseStateCopyWithImpl(
      _$_PurchaseState _value, $Res Function(_$_PurchaseState) _then)
      : super(_value, (v) => _then(v as _$_PurchaseState));

  @override
  _$_PurchaseState get _value => super._value as _$_PurchaseState;

  @override
  $Res call({
    Object? offerings = freezed,
  }) {
    return _then(_$_PurchaseState(
      offerings: offerings == freezed
          ? _value.offerings
          : offerings // ignore: cast_nullable_to_non_nullable
              as Offerings?,
    ));
  }
}

/// @nodoc

class _$_PurchaseState extends _PurchaseState {
  _$_PurchaseState({this.offerings}) : super._();

  @override
  final Offerings? offerings;

  @override
  String toString() {
    return 'PurchaseState(offerings: $offerings)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PurchaseState &&
            const DeepCollectionEquality().equals(other.offerings, offerings));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(offerings));

  @JsonKey(ignore: true)
  @override
  _$$_PurchaseStateCopyWith<_$_PurchaseState> get copyWith =>
      __$$_PurchaseStateCopyWithImpl<_$_PurchaseState>(this, _$identity);
}

abstract class _PurchaseState extends PurchaseState {
  factory _PurchaseState({final Offerings? offerings}) = _$_PurchaseState;
  _PurchaseState._() : super._();

  @override
  Offerings? get offerings;
  @override
  @JsonKey(ignore: true)
  _$$_PurchaseStateCopyWith<_$_PurchaseState> get copyWith =>
      throw _privateConstructorUsedError;
}
