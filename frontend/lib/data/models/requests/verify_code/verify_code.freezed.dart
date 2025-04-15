// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VerifyCode _$VerifyCodeFromJson(Map<String, dynamic> json) {
  return _VerifyCode.fromJson(json);
}

/// @nodoc
mixin _$VerifyCode {
  String get userId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;

  /// Serializes this VerifyCode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyCodeCopyWith<VerifyCode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyCodeCopyWith<$Res> {
  factory $VerifyCodeCopyWith(
          VerifyCode value, $Res Function(VerifyCode) then) =
      _$VerifyCodeCopyWithImpl<$Res, VerifyCode>;
  @useResult
  $Res call({String userId, String email, String code});
}

/// @nodoc
class _$VerifyCodeCopyWithImpl<$Res, $Val extends VerifyCode>
    implements $VerifyCodeCopyWith<$Res> {
  _$VerifyCodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? code = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerifyCodeImplCopyWith<$Res>
    implements $VerifyCodeCopyWith<$Res> {
  factory _$$VerifyCodeImplCopyWith(
          _$VerifyCodeImpl value, $Res Function(_$VerifyCodeImpl) then) =
      __$$VerifyCodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String email, String code});
}

/// @nodoc
class __$$VerifyCodeImplCopyWithImpl<$Res>
    extends _$VerifyCodeCopyWithImpl<$Res, _$VerifyCodeImpl>
    implements _$$VerifyCodeImplCopyWith<$Res> {
  __$$VerifyCodeImplCopyWithImpl(
      _$VerifyCodeImpl _value, $Res Function(_$VerifyCodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerifyCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? code = null,
  }) {
    return _then(_$VerifyCodeImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyCodeImpl implements _VerifyCode {
  const _$VerifyCodeImpl(
      {required this.userId, required this.email, required this.code});

  factory _$VerifyCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyCodeImplFromJson(json);

  @override
  final String userId;
  @override
  final String email;
  @override
  final String code;

  @override
  String toString() {
    return 'VerifyCode(userId: $userId, email: $email, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyCodeImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, email, code);

  /// Create a copy of VerifyCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyCodeImplCopyWith<_$VerifyCodeImpl> get copyWith =>
      __$$VerifyCodeImplCopyWithImpl<_$VerifyCodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyCodeImplToJson(
      this,
    );
  }
}

abstract class _VerifyCode implements VerifyCode {
  const factory _VerifyCode(
      {required final String userId,
      required final String email,
      required final String code}) = _$VerifyCodeImpl;

  factory _VerifyCode.fromJson(Map<String, dynamic> json) =
      _$VerifyCodeImpl.fromJson;

  @override
  String get userId;
  @override
  String get email;
  @override
  String get code;

  /// Create a copy of VerifyCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyCodeImplCopyWith<_$VerifyCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
