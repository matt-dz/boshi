// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_email.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AddEmail _$AddEmailFromJson(Map<String, dynamic> json) {
  return _AddEmail.fromJson(json);
}

/// @nodoc
mixin _$AddEmail {
  String get userId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;

  /// Serializes this AddEmail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddEmail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddEmailCopyWith<AddEmail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddEmailCopyWith<$Res> {
  factory $AddEmailCopyWith(AddEmail value, $Res Function(AddEmail) then) =
      _$AddEmailCopyWithImpl<$Res, AddEmail>;
  @useResult
  $Res call({String userId, String email});
}

/// @nodoc
class _$AddEmailCopyWithImpl<$Res, $Val extends AddEmail>
    implements $AddEmailCopyWith<$Res> {
  _$AddEmailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddEmail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddEmailImplCopyWith<$Res>
    implements $AddEmailCopyWith<$Res> {
  factory _$$AddEmailImplCopyWith(
          _$AddEmailImpl value, $Res Function(_$AddEmailImpl) then) =
      __$$AddEmailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String email});
}

/// @nodoc
class __$$AddEmailImplCopyWithImpl<$Res>
    extends _$AddEmailCopyWithImpl<$Res, _$AddEmailImpl>
    implements _$$AddEmailImplCopyWith<$Res> {
  __$$AddEmailImplCopyWithImpl(
      _$AddEmailImpl _value, $Res Function(_$AddEmailImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddEmail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
  }) {
    return _then(_$AddEmailImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddEmailImpl implements _AddEmail {
  const _$AddEmailImpl({required this.userId, required this.email});

  factory _$AddEmailImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddEmailImplFromJson(json);

  @override
  final String userId;
  @override
  final String email;

  @override
  String toString() {
    return 'AddEmail(userId: $userId, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddEmailImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, email);

  /// Create a copy of AddEmail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddEmailImplCopyWith<_$AddEmailImpl> get copyWith =>
      __$$AddEmailImplCopyWithImpl<_$AddEmailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddEmailImplToJson(
      this,
    );
  }
}

abstract class _AddEmail implements AddEmail {
  const factory _AddEmail(
      {required final String userId,
      required final String email}) = _$AddEmailImpl;

  factory _AddEmail.fromJson(Map<String, dynamic> json) =
      _$AddEmailImpl.fromJson;

  @override
  String get userId;
  @override
  String get email;

  /// Create a copy of AddEmail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddEmailImplCopyWith<_$AddEmailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
