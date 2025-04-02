// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reaction_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReactionPayload _$ReactionPayloadFromJson(Map<String, dynamic> json) {
  return _ReactionPayload.fromJson(json);
}

/// @nodoc
mixin _$ReactionPayload {
  String get emote => throw _privateConstructorUsedError;
  int get delta => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;

  /// Serializes this ReactionPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReactionPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReactionPayloadCopyWith<ReactionPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactionPayloadCopyWith<$Res> {
  factory $ReactionPayloadCopyWith(
          ReactionPayload value, $Res Function(ReactionPayload) then) =
      _$ReactionPayloadCopyWithImpl<$Res, ReactionPayload>;
  @useResult
  $Res call({String emote, int delta, String postId});
}

/// @nodoc
class _$ReactionPayloadCopyWithImpl<$Res, $Val extends ReactionPayload>
    implements $ReactionPayloadCopyWith<$Res> {
  _$ReactionPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReactionPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emote = null,
    Object? delta = null,
    Object? postId = null,
  }) {
    return _then(_value.copyWith(
      emote: null == emote
          ? _value.emote
          : emote // ignore: cast_nullable_to_non_nullable
              as String,
      delta: null == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as int,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReactionPayloadImplCopyWith<$Res>
    implements $ReactionPayloadCopyWith<$Res> {
  factory _$$ReactionPayloadImplCopyWith(_$ReactionPayloadImpl value,
          $Res Function(_$ReactionPayloadImpl) then) =
      __$$ReactionPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String emote, int delta, String postId});
}

/// @nodoc
class __$$ReactionPayloadImplCopyWithImpl<$Res>
    extends _$ReactionPayloadCopyWithImpl<$Res, _$ReactionPayloadImpl>
    implements _$$ReactionPayloadImplCopyWith<$Res> {
  __$$ReactionPayloadImplCopyWithImpl(
      _$ReactionPayloadImpl _value, $Res Function(_$ReactionPayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReactionPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emote = null,
    Object? delta = null,
    Object? postId = null,
  }) {
    return _then(_$ReactionPayloadImpl(
      emote: null == emote
          ? _value.emote
          : emote // ignore: cast_nullable_to_non_nullable
              as String,
      delta: null == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as int,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReactionPayloadImpl implements _ReactionPayload {
  const _$ReactionPayloadImpl(
      {required this.emote, required this.delta, required this.postId});

  factory _$ReactionPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReactionPayloadImplFromJson(json);

  @override
  final String emote;
  @override
  final int delta;
  @override
  final String postId;

  @override
  String toString() {
    return 'ReactionPayload(emote: $emote, delta: $delta, postId: $postId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionPayloadImpl &&
            (identical(other.emote, emote) || other.emote == emote) &&
            (identical(other.delta, delta) || other.delta == delta) &&
            (identical(other.postId, postId) || other.postId == postId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, emote, delta, postId);

  /// Create a copy of ReactionPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReactionPayloadImplCopyWith<_$ReactionPayloadImpl> get copyWith =>
      __$$ReactionPayloadImplCopyWithImpl<_$ReactionPayloadImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReactionPayloadImplToJson(
      this,
    );
  }
}

abstract class _ReactionPayload implements ReactionPayload {
  const factory _ReactionPayload(
      {required final String emote,
      required final int delta,
      required final String postId}) = _$ReactionPayloadImpl;

  factory _ReactionPayload.fromJson(Map<String, dynamic> json) =
      _$ReactionPayloadImpl.fromJson;

  @override
  String get emote;
  @override
  int get delta;
  @override
  String get postId;

  /// Create a copy of ReactionPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReactionPayloadImplCopyWith<_$ReactionPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
