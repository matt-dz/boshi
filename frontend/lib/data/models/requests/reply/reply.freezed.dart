// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reply.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Reply _$ReplyFromJson(Map<String, dynamic> json) {
  return _Reply.fromJson(json);
}

/// @nodoc
mixin _$Reply {
  String get rootCid => throw _privateConstructorUsedError;
  String get rootUri => throw _privateConstructorUsedError;
  String get postCid => throw _privateConstructorUsedError;
  String get postUri => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  /// Serializes this Reply to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReplyCopyWith<Reply> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReplyCopyWith<$Res> {
  factory $ReplyCopyWith(Reply value, $Res Function(Reply) then) =
      _$ReplyCopyWithImpl<$Res, Reply>;
  @useResult
  $Res call(
      {String rootCid,
      String rootUri,
      String postCid,
      String postUri,
      String authorId,
      String content});
}

/// @nodoc
class _$ReplyCopyWithImpl<$Res, $Val extends Reply>
    implements $ReplyCopyWith<$Res> {
  _$ReplyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rootCid = null,
    Object? rootUri = null,
    Object? postCid = null,
    Object? postUri = null,
    Object? authorId = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      rootCid: null == rootCid
          ? _value.rootCid
          : rootCid // ignore: cast_nullable_to_non_nullable
              as String,
      rootUri: null == rootUri
          ? _value.rootUri
          : rootUri // ignore: cast_nullable_to_non_nullable
              as String,
      postCid: null == postCid
          ? _value.postCid
          : postCid // ignore: cast_nullable_to_non_nullable
              as String,
      postUri: null == postUri
          ? _value.postUri
          : postUri // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReplyImplCopyWith<$Res> implements $ReplyCopyWith<$Res> {
  factory _$$ReplyImplCopyWith(
          _$ReplyImpl value, $Res Function(_$ReplyImpl) then) =
      __$$ReplyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String rootCid,
      String rootUri,
      String postCid,
      String postUri,
      String authorId,
      String content});
}

/// @nodoc
class __$$ReplyImplCopyWithImpl<$Res>
    extends _$ReplyCopyWithImpl<$Res, _$ReplyImpl>
    implements _$$ReplyImplCopyWith<$Res> {
  __$$ReplyImplCopyWithImpl(
      _$ReplyImpl _value, $Res Function(_$ReplyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rootCid = null,
    Object? rootUri = null,
    Object? postCid = null,
    Object? postUri = null,
    Object? authorId = null,
    Object? content = null,
  }) {
    return _then(_$ReplyImpl(
      rootCid: null == rootCid
          ? _value.rootCid
          : rootCid // ignore: cast_nullable_to_non_nullable
              as String,
      rootUri: null == rootUri
          ? _value.rootUri
          : rootUri // ignore: cast_nullable_to_non_nullable
              as String,
      postCid: null == postCid
          ? _value.postCid
          : postCid // ignore: cast_nullable_to_non_nullable
              as String,
      postUri: null == postUri
          ? _value.postUri
          : postUri // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReplyImpl implements _Reply {
  const _$ReplyImpl(
      {required this.rootCid,
      required this.rootUri,
      required this.postCid,
      required this.postUri,
      required this.authorId,
      required this.content});

  factory _$ReplyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReplyImplFromJson(json);

  @override
  final String rootCid;
  @override
  final String rootUri;
  @override
  final String postCid;
  @override
  final String postUri;
  @override
  final String authorId;
  @override
  final String content;

  @override
  String toString() {
    return 'Reply(rootCid: $rootCid, rootUri: $rootUri, postCid: $postCid, postUri: $postUri, authorId: $authorId, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReplyImpl &&
            (identical(other.rootCid, rootCid) || other.rootCid == rootCid) &&
            (identical(other.rootUri, rootUri) || other.rootUri == rootUri) &&
            (identical(other.postCid, postCid) || other.postCid == postCid) &&
            (identical(other.postUri, postUri) || other.postUri == postUri) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, rootCid, rootUri, postCid, postUri, authorId, content);

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReplyImplCopyWith<_$ReplyImpl> get copyWith =>
      __$$ReplyImplCopyWithImpl<_$ReplyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReplyImplToJson(
      this,
    );
  }
}

abstract class _Reply implements Reply {
  const factory _Reply(
      {required final String rootCid,
      required final String rootUri,
      required final String postCid,
      required final String postUri,
      required final String authorId,
      required final String content}) = _$ReplyImpl;

  factory _Reply.fromJson(Map<String, dynamic> json) = _$ReplyImpl.fromJson;

  @override
  String get rootCid;
  @override
  String get rootUri;
  @override
  String get postCid;
  @override
  String get postUri;
  @override
  String get authorId;
  @override
  String get content;

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReplyImplCopyWith<_$ReplyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
