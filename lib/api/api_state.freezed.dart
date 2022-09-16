// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'api_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$WeatherClassState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(WeatherClass weatherClass) success,
    required TResult Function(String? message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WeatherClass weatherClass)? success,
    TResult Function(String? message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WeatherClass weatherClass)? success,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WeatherInitial value) initial,
    required TResult Function(_WeatherLoading value) loading,
    required TResult Function(_WeatherLoadedSuccess value) success,
    required TResult Function(_WeatherLoadedError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WeatherInitial value)? initial,
    TResult Function(_WeatherLoading value)? loading,
    TResult Function(_WeatherLoadedSuccess value)? success,
    TResult Function(_WeatherLoadedError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WeatherInitial value)? initial,
    TResult Function(_WeatherLoading value)? loading,
    TResult Function(_WeatherLoadedSuccess value)? success,
    TResult Function(_WeatherLoadedError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherClassStateCopyWith<$Res> {
  factory $WeatherClassStateCopyWith(
          WeatherClassState value, $Res Function(WeatherClassState) then) =
      _$WeatherClassStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$WeatherClassStateCopyWithImpl<$Res>
    implements $WeatherClassStateCopyWith<$Res> {
  _$WeatherClassStateCopyWithImpl(this._value, this._then);

  final WeatherClassState _value;
  // ignore: unused_field
  final $Res Function(WeatherClassState) _then;
}

/// @nodoc
abstract class _$$_WeatherInitialCopyWith<$Res> {
  factory _$$_WeatherInitialCopyWith(
          _$_WeatherInitial value, $Res Function(_$_WeatherInitial) then) =
      __$$_WeatherInitialCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_WeatherInitialCopyWithImpl<$Res>
    extends _$WeatherClassStateCopyWithImpl<$Res>
    implements _$$_WeatherInitialCopyWith<$Res> {
  __$$_WeatherInitialCopyWithImpl(
      _$_WeatherInitial _value, $Res Function(_$_WeatherInitial) _then)
      : super(_value, (v) => _then(v as _$_WeatherInitial));

  @override
  _$_WeatherInitial get _value => super._value as _$_WeatherInitial;
}

/// @nodoc

class _$_WeatherInitial implements _WeatherInitial {
  const _$_WeatherInitial();

  @override
  String toString() {
    return 'WeatherClassState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_WeatherInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(WeatherClass weatherClass) success,
    required TResult Function(String? message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WeatherClass weatherClass)? success,
    TResult Function(String? message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WeatherClass weatherClass)? success,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WeatherInitial value) initial,
    required TResult Function(_WeatherLoading value) loading,
    required TResult Function(_WeatherLoadedSuccess value) success,
    required TResult Function(_WeatherLoadedError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WeatherInitial value)? initial,
    TResult Function(_WeatherLoading value)? loading,
    TResult Function(_WeatherLoadedSuccess value)? success,
    TResult Function(_WeatherLoadedError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WeatherInitial value)? initial,
    TResult Function(_WeatherLoading value)? loading,
    TResult Function(_WeatherLoadedSuccess value)? success,
    TResult Function(_WeatherLoadedError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _WeatherInitial implements WeatherClassState {
  const factory _WeatherInitial() = _$_WeatherInitial;
}

/// @nodoc
abstract class _$$_WeatherLoadingCopyWith<$Res> {
  factory _$$_WeatherLoadingCopyWith(
          _$_WeatherLoading value, $Res Function(_$_WeatherLoading) then) =
      __$$_WeatherLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_WeatherLoadingCopyWithImpl<$Res>
    extends _$WeatherClassStateCopyWithImpl<$Res>
    implements _$$_WeatherLoadingCopyWith<$Res> {
  __$$_WeatherLoadingCopyWithImpl(
      _$_WeatherLoading _value, $Res Function(_$_WeatherLoading) _then)
      : super(_value, (v) => _then(v as _$_WeatherLoading));

  @override
  _$_WeatherLoading get _value => super._value as _$_WeatherLoading;
}

/// @nodoc

class _$_WeatherLoading implements _WeatherLoading {
  const _$_WeatherLoading();

  @override
  String toString() {
    return 'WeatherClassState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_WeatherLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(WeatherClass weatherClass) success,
    required TResult Function(String? message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WeatherClass weatherClass)? success,
    TResult Function(String? message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WeatherClass weatherClass)? success,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WeatherInitial value) initial,
    required TResult Function(_WeatherLoading value) loading,
    required TResult Function(_WeatherLoadedSuccess value) success,
    required TResult Function(_WeatherLoadedError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WeatherInitial value)? initial,
    TResult Function(_WeatherLoading value)? loading,
    TResult Function(_WeatherLoadedSuccess value)? success,
    TResult Function(_WeatherLoadedError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WeatherInitial value)? initial,
    TResult Function(_WeatherLoading value)? loading,
    TResult Function(_WeatherLoadedSuccess value)? success,
    TResult Function(_WeatherLoadedError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _WeatherLoading implements WeatherClassState {
  const factory _WeatherLoading() = _$_WeatherLoading;
}

/// @nodoc
abstract class _$$_WeatherLoadedSuccessCopyWith<$Res> {
  factory _$$_WeatherLoadedSuccessCopyWith(_$_WeatherLoadedSuccess value,
          $Res Function(_$_WeatherLoadedSuccess) then) =
      __$$_WeatherLoadedSuccessCopyWithImpl<$Res>;
  $Res call({WeatherClass weatherClass});

  $WeatherClassCopyWith<$Res> get weatherClass;
}

/// @nodoc
class __$$_WeatherLoadedSuccessCopyWithImpl<$Res>
    extends _$WeatherClassStateCopyWithImpl<$Res>
    implements _$$_WeatherLoadedSuccessCopyWith<$Res> {
  __$$_WeatherLoadedSuccessCopyWithImpl(_$_WeatherLoadedSuccess _value,
      $Res Function(_$_WeatherLoadedSuccess) _then)
      : super(_value, (v) => _then(v as _$_WeatherLoadedSuccess));

  @override
  _$_WeatherLoadedSuccess get _value => super._value as _$_WeatherLoadedSuccess;

  @override
  $Res call({
    Object? weatherClass = freezed,
  }) {
    return _then(_$_WeatherLoadedSuccess(
      weatherClass == freezed
          ? _value.weatherClass
          : weatherClass // ignore: cast_nullable_to_non_nullable
              as WeatherClass,
    ));
  }

  @override
  $WeatherClassCopyWith<$Res> get weatherClass {
    return $WeatherClassCopyWith<$Res>(_value.weatherClass, (value) {
      return _then(_value.copyWith(weatherClass: value));
    });
  }
}

/// @nodoc

class _$_WeatherLoadedSuccess implements _WeatherLoadedSuccess {
  const _$_WeatherLoadedSuccess(this.weatherClass);

  @override
  final WeatherClass weatherClass;

  @override
  String toString() {
    return 'WeatherClassState.success(weatherClass: $weatherClass)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WeatherLoadedSuccess &&
            const DeepCollectionEquality()
                .equals(other.weatherClass, weatherClass));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(weatherClass));

  @JsonKey(ignore: true)
  @override
  _$$_WeatherLoadedSuccessCopyWith<_$_WeatherLoadedSuccess> get copyWith =>
      __$$_WeatherLoadedSuccessCopyWithImpl<_$_WeatherLoadedSuccess>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(WeatherClass weatherClass) success,
    required TResult Function(String? message) error,
  }) {
    return success(weatherClass);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WeatherClass weatherClass)? success,
    TResult Function(String? message)? error,
  }) {
    return success?.call(weatherClass);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WeatherClass weatherClass)? success,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(weatherClass);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WeatherInitial value) initial,
    required TResult Function(_WeatherLoading value) loading,
    required TResult Function(_WeatherLoadedSuccess value) success,
    required TResult Function(_WeatherLoadedError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WeatherInitial value)? initial,
    TResult Function(_WeatherLoading value)? loading,
    TResult Function(_WeatherLoadedSuccess value)? success,
    TResult Function(_WeatherLoadedError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WeatherInitial value)? initial,
    TResult Function(_WeatherLoading value)? loading,
    TResult Function(_WeatherLoadedSuccess value)? success,
    TResult Function(_WeatherLoadedError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _WeatherLoadedSuccess implements WeatherClassState {
  const factory _WeatherLoadedSuccess(final WeatherClass weatherClass) =
      _$_WeatherLoadedSuccess;

  WeatherClass get weatherClass;
  @JsonKey(ignore: true)
  _$$_WeatherLoadedSuccessCopyWith<_$_WeatherLoadedSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_WeatherLoadedErrorCopyWith<$Res> {
  factory _$$_WeatherLoadedErrorCopyWith(_$_WeatherLoadedError value,
          $Res Function(_$_WeatherLoadedError) then) =
      __$$_WeatherLoadedErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$$_WeatherLoadedErrorCopyWithImpl<$Res>
    extends _$WeatherClassStateCopyWithImpl<$Res>
    implements _$$_WeatherLoadedErrorCopyWith<$Res> {
  __$$_WeatherLoadedErrorCopyWithImpl(
      _$_WeatherLoadedError _value, $Res Function(_$_WeatherLoadedError) _then)
      : super(_value, (v) => _then(v as _$_WeatherLoadedError));

  @override
  _$_WeatherLoadedError get _value => super._value as _$_WeatherLoadedError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$_WeatherLoadedError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_WeatherLoadedError implements _WeatherLoadedError {
  const _$_WeatherLoadedError([this.message]);

  @override
  final String? message;

  @override
  String toString() {
    return 'WeatherClassState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WeatherLoadedError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$_WeatherLoadedErrorCopyWith<_$_WeatherLoadedError> get copyWith =>
      __$$_WeatherLoadedErrorCopyWithImpl<_$_WeatherLoadedError>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(WeatherClass weatherClass) success,
    required TResult Function(String? message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WeatherClass weatherClass)? success,
    TResult Function(String? message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WeatherClass weatherClass)? success,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WeatherInitial value) initial,
    required TResult Function(_WeatherLoading value) loading,
    required TResult Function(_WeatherLoadedSuccess value) success,
    required TResult Function(_WeatherLoadedError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WeatherInitial value)? initial,
    TResult Function(_WeatherLoading value)? loading,
    TResult Function(_WeatherLoadedSuccess value)? success,
    TResult Function(_WeatherLoadedError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WeatherInitial value)? initial,
    TResult Function(_WeatherLoading value)? loading,
    TResult Function(_WeatherLoadedSuccess value)? success,
    TResult Function(_WeatherLoadedError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _WeatherLoadedError implements WeatherClassState {
  const factory _WeatherLoadedError([final String? message]) =
      _$_WeatherLoadedError;

  String? get message;
  @JsonKey(ignore: true)
  _$$_WeatherLoadedErrorCopyWith<_$_WeatherLoadedError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LocationState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String address) success,
    required TResult Function(String? message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String address)? success,
    TResult Function(String? message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String address)? success,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LocationInitial value) initial,
    required TResult Function(_LocationLoading value) loading,
    required TResult Function(_LocationSuccess value) success,
    required TResult Function(_LocationLoadedError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LocationInitial value)? initial,
    TResult Function(_LocationLoading value)? loading,
    TResult Function(_LocationSuccess value)? success,
    TResult Function(_LocationLoadedError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LocationInitial value)? initial,
    TResult Function(_LocationLoading value)? loading,
    TResult Function(_LocationSuccess value)? success,
    TResult Function(_LocationLoadedError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationStateCopyWith<$Res> {
  factory $LocationStateCopyWith(
          LocationState value, $Res Function(LocationState) then) =
      _$LocationStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$LocationStateCopyWithImpl<$Res>
    implements $LocationStateCopyWith<$Res> {
  _$LocationStateCopyWithImpl(this._value, this._then);

  final LocationState _value;
  // ignore: unused_field
  final $Res Function(LocationState) _then;
}

/// @nodoc
abstract class _$$_LocationInitialCopyWith<$Res> {
  factory _$$_LocationInitialCopyWith(
          _$_LocationInitial value, $Res Function(_$_LocationInitial) then) =
      __$$_LocationInitialCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_LocationInitialCopyWithImpl<$Res>
    extends _$LocationStateCopyWithImpl<$Res>
    implements _$$_LocationInitialCopyWith<$Res> {
  __$$_LocationInitialCopyWithImpl(
      _$_LocationInitial _value, $Res Function(_$_LocationInitial) _then)
      : super(_value, (v) => _then(v as _$_LocationInitial));

  @override
  _$_LocationInitial get _value => super._value as _$_LocationInitial;
}

/// @nodoc

class _$_LocationInitial implements _LocationInitial {
  const _$_LocationInitial();

  @override
  String toString() {
    return 'LocationState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_LocationInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String address) success,
    required TResult Function(String? message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String address)? success,
    TResult Function(String? message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String address)? success,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LocationInitial value) initial,
    required TResult Function(_LocationLoading value) loading,
    required TResult Function(_LocationSuccess value) success,
    required TResult Function(_LocationLoadedError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LocationInitial value)? initial,
    TResult Function(_LocationLoading value)? loading,
    TResult Function(_LocationSuccess value)? success,
    TResult Function(_LocationLoadedError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LocationInitial value)? initial,
    TResult Function(_LocationLoading value)? loading,
    TResult Function(_LocationSuccess value)? success,
    TResult Function(_LocationLoadedError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _LocationInitial implements LocationState {
  const factory _LocationInitial() = _$_LocationInitial;
}

/// @nodoc
abstract class _$$_LocationLoadingCopyWith<$Res> {
  factory _$$_LocationLoadingCopyWith(
          _$_LocationLoading value, $Res Function(_$_LocationLoading) then) =
      __$$_LocationLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_LocationLoadingCopyWithImpl<$Res>
    extends _$LocationStateCopyWithImpl<$Res>
    implements _$$_LocationLoadingCopyWith<$Res> {
  __$$_LocationLoadingCopyWithImpl(
      _$_LocationLoading _value, $Res Function(_$_LocationLoading) _then)
      : super(_value, (v) => _then(v as _$_LocationLoading));

  @override
  _$_LocationLoading get _value => super._value as _$_LocationLoading;
}

/// @nodoc

class _$_LocationLoading implements _LocationLoading {
  const _$_LocationLoading();

  @override
  String toString() {
    return 'LocationState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_LocationLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String address) success,
    required TResult Function(String? message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String address)? success,
    TResult Function(String? message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String address)? success,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LocationInitial value) initial,
    required TResult Function(_LocationLoading value) loading,
    required TResult Function(_LocationSuccess value) success,
    required TResult Function(_LocationLoadedError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LocationInitial value)? initial,
    TResult Function(_LocationLoading value)? loading,
    TResult Function(_LocationSuccess value)? success,
    TResult Function(_LocationLoadedError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LocationInitial value)? initial,
    TResult Function(_LocationLoading value)? loading,
    TResult Function(_LocationSuccess value)? success,
    TResult Function(_LocationLoadedError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _LocationLoading implements LocationState {
  const factory _LocationLoading() = _$_LocationLoading;
}

/// @nodoc
abstract class _$$_LocationSuccessCopyWith<$Res> {
  factory _$$_LocationSuccessCopyWith(
          _$_LocationSuccess value, $Res Function(_$_LocationSuccess) then) =
      __$$_LocationSuccessCopyWithImpl<$Res>;
  $Res call({String address});
}

/// @nodoc
class __$$_LocationSuccessCopyWithImpl<$Res>
    extends _$LocationStateCopyWithImpl<$Res>
    implements _$$_LocationSuccessCopyWith<$Res> {
  __$$_LocationSuccessCopyWithImpl(
      _$_LocationSuccess _value, $Res Function(_$_LocationSuccess) _then)
      : super(_value, (v) => _then(v as _$_LocationSuccess));

  @override
  _$_LocationSuccess get _value => super._value as _$_LocationSuccess;

  @override
  $Res call({
    Object? address = freezed,
  }) {
    return _then(_$_LocationSuccess(
      address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_LocationSuccess implements _LocationSuccess {
  const _$_LocationSuccess(this.address);

  @override
  final String address;

  @override
  String toString() {
    return 'LocationState.success(address: $address)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LocationSuccess &&
            const DeepCollectionEquality().equals(other.address, address));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(address));

  @JsonKey(ignore: true)
  @override
  _$$_LocationSuccessCopyWith<_$_LocationSuccess> get copyWith =>
      __$$_LocationSuccessCopyWithImpl<_$_LocationSuccess>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String address) success,
    required TResult Function(String? message) error,
  }) {
    return success(address);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String address)? success,
    TResult Function(String? message)? error,
  }) {
    return success?.call(address);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String address)? success,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(address);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LocationInitial value) initial,
    required TResult Function(_LocationLoading value) loading,
    required TResult Function(_LocationSuccess value) success,
    required TResult Function(_LocationLoadedError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LocationInitial value)? initial,
    TResult Function(_LocationLoading value)? loading,
    TResult Function(_LocationSuccess value)? success,
    TResult Function(_LocationLoadedError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LocationInitial value)? initial,
    TResult Function(_LocationLoading value)? loading,
    TResult Function(_LocationSuccess value)? success,
    TResult Function(_LocationLoadedError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _LocationSuccess implements LocationState {
  const factory _LocationSuccess(final String address) = _$_LocationSuccess;

  String get address;
  @JsonKey(ignore: true)
  _$$_LocationSuccessCopyWith<_$_LocationSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_LocationLoadedErrorCopyWith<$Res> {
  factory _$$_LocationLoadedErrorCopyWith(_$_LocationLoadedError value,
          $Res Function(_$_LocationLoadedError) then) =
      __$$_LocationLoadedErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$$_LocationLoadedErrorCopyWithImpl<$Res>
    extends _$LocationStateCopyWithImpl<$Res>
    implements _$$_LocationLoadedErrorCopyWith<$Res> {
  __$$_LocationLoadedErrorCopyWithImpl(_$_LocationLoadedError _value,
      $Res Function(_$_LocationLoadedError) _then)
      : super(_value, (v) => _then(v as _$_LocationLoadedError));

  @override
  _$_LocationLoadedError get _value => super._value as _$_LocationLoadedError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$_LocationLoadedError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_LocationLoadedError implements _LocationLoadedError {
  const _$_LocationLoadedError([this.message]);

  @override
  final String? message;

  @override
  String toString() {
    return 'LocationState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LocationLoadedError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$_LocationLoadedErrorCopyWith<_$_LocationLoadedError> get copyWith =>
      __$$_LocationLoadedErrorCopyWithImpl<_$_LocationLoadedError>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String address) success,
    required TResult Function(String? message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String address)? success,
    TResult Function(String? message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String address)? success,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LocationInitial value) initial,
    required TResult Function(_LocationLoading value) loading,
    required TResult Function(_LocationSuccess value) success,
    required TResult Function(_LocationLoadedError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_LocationInitial value)? initial,
    TResult Function(_LocationLoading value)? loading,
    TResult Function(_LocationSuccess value)? success,
    TResult Function(_LocationLoadedError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LocationInitial value)? initial,
    TResult Function(_LocationLoading value)? loading,
    TResult Function(_LocationSuccess value)? success,
    TResult Function(_LocationLoadedError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _LocationLoadedError implements LocationState {
  const factory _LocationLoadedError([final String? message]) =
      _$_LocationLoadedError;

  String? get message;
  @JsonKey(ignore: true)
  _$$_LocationLoadedErrorCopyWith<_$_LocationLoadedError> get copyWith =>
      throw _privateConstructorUsedError;
}
