// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_code_ttl.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VerificationCodeTTL _$VerificationCodeTTLFromJson(Map<String, dynamic> json) {
  return _VerificationCodeTTL.fromJson(json);
}

/// @nodoc
mixin _$VerificationCodeTTL {
  double get ttl => throw _privateConstructorUsedError;

  /// Serializes this VerificationCodeTTL to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerificationCodeTTL
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerificationCodeTTLCopyWith<VerificationCodeTTL> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationCodeTTLCopyWith<$Res> {
  factory $VerificationCodeTTLCopyWith(
          VerificationCodeTTL value, $Res Function(VerificationCodeTTL) then) =
      _$VerificationCodeTTLCopyWithImpl<$Res, VerificationCodeTTL>;
  @useResult
  $Res call({double ttl});
}

/// @nodoc
class _$VerificationCodeTTLCopyWithImpl<$Res, $Val extends VerificationCodeTTL>
    implements $VerificationCodeTTLCopyWith<$Res> {
  _$VerificationCodeTTLCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerificationCodeTTL
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ttl = null,
  }) {
    return _then(_value.copyWith(
      ttl: null == ttl
          ? _value.ttl
          : ttl // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerificationCodeTTLImplCopyWith<$Res>
    implements $VerificationCodeTTLCopyWith<$Res> {
  factory _$$VerificationCodeTTLImplCopyWith(_$VerificationCodeTTLImpl value,
          $Res Function(_$VerificationCodeTTLImpl) then) =
      __$$VerificationCodeTTLImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double ttl});
}

/// @nodoc
class __$$VerificationCodeTTLImplCopyWithImpl<$Res>
    extends _$VerificationCodeTTLCopyWithImpl<$Res, _$VerificationCodeTTLImpl>
    implements _$$VerificationCodeTTLImplCopyWith<$Res> {
  __$$VerificationCodeTTLImplCopyWithImpl(_$VerificationCodeTTLImpl _value,
      $Res Function(_$VerificationCodeTTLImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerificationCodeTTL
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ttl = null,
  }) {
    return _then(_$VerificationCodeTTLImpl(
      ttl: null == ttl
          ? _value.ttl
          : ttl // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationCodeTTLImpl implements _VerificationCodeTTL {
  const _$VerificationCodeTTLImpl({required this.ttl});

  factory _$VerificationCodeTTLImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationCodeTTLImplFromJson(json);

  @override
  final double ttl;

  @override
  String toString() {
    return 'VerificationCodeTTL(ttl: $ttl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationCodeTTLImpl &&
            (identical(other.ttl, ttl) || other.ttl == ttl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ttl);

  /// Create a copy of VerificationCodeTTL
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationCodeTTLImplCopyWith<_$VerificationCodeTTLImpl> get copyWith =>
      __$$VerificationCodeTTLImplCopyWithImpl<_$VerificationCodeTTLImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationCodeTTLImplToJson(
      this,
    );
  }
}

abstract class _VerificationCodeTTL implements VerificationCodeTTL {
  const factory _VerificationCodeTTL({required final double ttl}) =
      _$VerificationCodeTTLImpl;

  factory _VerificationCodeTTL.fromJson(Map<String, dynamic> json) =
      _$VerificationCodeTTLImpl.fromJson;

  @override
  double get ttl;

  /// Create a copy of VerificationCodeTTL
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerificationCodeTTLImplCopyWith<_$VerificationCodeTTLImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
