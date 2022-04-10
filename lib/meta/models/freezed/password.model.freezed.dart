// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'password.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Password _$PasswordFromJson(Map<String, dynamic> json) {
  return _Password.fromJson(json);
}

/// @nodoc
class _$PasswordTearOff {
  const _$PasswordTearOff();

  _Password call(
      {required String favicon,
      required String? name,
      required String? password}) {
    return _Password(
      favicon: favicon,
      name: name,
      password: password,
    );
  }

  Password fromJson(Map<String, Object?> json) {
    return Password.fromJson(json);
  }
}

/// @nodoc
const $Password = _$PasswordTearOff();

/// @nodoc
mixin _$Password {
  String get favicon => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PasswordCopyWith<Password> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordCopyWith<$Res> {
  factory $PasswordCopyWith(Password value, $Res Function(Password) then) =
      _$PasswordCopyWithImpl<$Res>;
  $Res call({String favicon, String? name, String? password});
}

/// @nodoc
class _$PasswordCopyWithImpl<$Res> implements $PasswordCopyWith<$Res> {
  _$PasswordCopyWithImpl(this._value, this._then);

  final Password _value;
  // ignore: unused_field
  final $Res Function(Password) _then;

  @override
  $Res call({
    Object? favicon = freezed,
    Object? name = freezed,
    Object? password = freezed,
  }) {
    return _then(_value.copyWith(
      favicon: favicon == freezed
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$PasswordCopyWith<$Res> implements $PasswordCopyWith<$Res> {
  factory _$PasswordCopyWith(_Password value, $Res Function(_Password) then) =
      __$PasswordCopyWithImpl<$Res>;
  @override
  $Res call({String favicon, String? name, String? password});
}

/// @nodoc
class __$PasswordCopyWithImpl<$Res> extends _$PasswordCopyWithImpl<$Res>
    implements _$PasswordCopyWith<$Res> {
  __$PasswordCopyWithImpl(_Password _value, $Res Function(_Password) _then)
      : super(_value, (v) => _then(v as _Password));

  @override
  _Password get _value => super._value as _Password;

  @override
  $Res call({
    Object? favicon = freezed,
    Object? name = freezed,
    Object? password = freezed,
  }) {
    return _then(_Password(
      favicon: favicon == freezed
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Password implements _Password {
  const _$_Password(
      {required this.favicon, required this.name, required this.password});

  factory _$_Password.fromJson(Map<String, dynamic> json) =>
      _$$_PasswordFromJson(json);

  @override
  final String favicon;
  @override
  final String? name;
  @override
  final String? password;

  @override
  String toString() {
    return 'Password(favicon: $favicon, name: $name, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Password &&
            const DeepCollectionEquality().equals(other.favicon, favicon) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.password, password));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(favicon),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(password));

  @JsonKey(ignore: true)
  @override
  _$PasswordCopyWith<_Password> get copyWith =>
      __$PasswordCopyWithImpl<_Password>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PasswordToJson(this);
  }
}

abstract class _Password implements Password {
  const factory _Password(
      {required String favicon,
      required String? name,
      required String? password}) = _$_Password;

  factory _Password.fromJson(Map<String, dynamic> json) = _$_Password.fromJson;

  @override
  String get favicon;
  @override
  String? get name;
  @override
  String? get password;
  @override
  @JsonKey(ignore: true)
  _$PasswordCopyWith<_Password> get copyWith =>
      throw _privateConstructorUsedError;
}