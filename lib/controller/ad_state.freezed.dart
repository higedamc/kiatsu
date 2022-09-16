// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'ad_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BannerAdState {
  Ad? get bannerAd => throw _privateConstructorUsedError;
  bool get isLoaded => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BannerAdStateCopyWith<BannerAdState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BannerAdStateCopyWith<$Res> {
  factory $BannerAdStateCopyWith(
          BannerAdState value, $Res Function(BannerAdState) then) =
      _$BannerAdStateCopyWithImpl<$Res>;
  $Res call({Ad? bannerAd, bool isLoaded});
}

/// @nodoc
class _$BannerAdStateCopyWithImpl<$Res>
    implements $BannerAdStateCopyWith<$Res> {
  _$BannerAdStateCopyWithImpl(this._value, this._then);

  final BannerAdState _value;
  // ignore: unused_field
  final $Res Function(BannerAdState) _then;

  @override
  $Res call({
    Object? bannerAd = freezed,
    Object? isLoaded = freezed,
  }) {
    return _then(_value.copyWith(
      bannerAd: bannerAd == freezed
          ? _value.bannerAd
          : bannerAd // ignore: cast_nullable_to_non_nullable
              as Ad?,
      isLoaded: isLoaded == freezed
          ? _value.isLoaded
          : isLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_BannerAdStateCopyWith<$Res>
    implements $BannerAdStateCopyWith<$Res> {
  factory _$$_BannerAdStateCopyWith(
          _$_BannerAdState value, $Res Function(_$_BannerAdState) then) =
      __$$_BannerAdStateCopyWithImpl<$Res>;
  @override
  $Res call({Ad? bannerAd, bool isLoaded});
}

/// @nodoc
class __$$_BannerAdStateCopyWithImpl<$Res>
    extends _$BannerAdStateCopyWithImpl<$Res>
    implements _$$_BannerAdStateCopyWith<$Res> {
  __$$_BannerAdStateCopyWithImpl(
      _$_BannerAdState _value, $Res Function(_$_BannerAdState) _then)
      : super(_value, (v) => _then(v as _$_BannerAdState));

  @override
  _$_BannerAdState get _value => super._value as _$_BannerAdState;

  @override
  $Res call({
    Object? bannerAd = freezed,
    Object? isLoaded = freezed,
  }) {
    return _then(_$_BannerAdState(
      bannerAd: bannerAd == freezed
          ? _value.bannerAd
          : bannerAd // ignore: cast_nullable_to_non_nullable
              as Ad?,
      isLoaded: isLoaded == freezed
          ? _value.isLoaded
          : isLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_BannerAdState implements _BannerAdState {
  const _$_BannerAdState({this.bannerAd, this.isLoaded = false});

  @override
  final Ad? bannerAd;
  @override
  @JsonKey()
  final bool isLoaded;

  @override
  String toString() {
    return 'BannerAdState(bannerAd: $bannerAd, isLoaded: $isLoaded)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BannerAdState &&
            const DeepCollectionEquality().equals(other.bannerAd, bannerAd) &&
            const DeepCollectionEquality().equals(other.isLoaded, isLoaded));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(bannerAd),
      const DeepCollectionEquality().hash(isLoaded));

  @JsonKey(ignore: true)
  @override
  _$$_BannerAdStateCopyWith<_$_BannerAdState> get copyWith =>
      __$$_BannerAdStateCopyWithImpl<_$_BannerAdState>(this, _$identity);
}

abstract class _BannerAdState implements BannerAdState {
  const factory _BannerAdState({final Ad? bannerAd, final bool isLoaded}) =
      _$_BannerAdState;

  @override
  Ad? get bannerAd;
  @override
  bool get isLoaded;
  @override
  @JsonKey(ignore: true)
  _$$_BannerAdStateCopyWith<_$_BannerAdState> get copyWith =>
      throw _privateConstructorUsedError;
}
