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

/// @nodoc
mixin _$Reply {
  AtUri get uri => throw _privateConstructorUsedError;
  String get cid => throw _privateConstructorUsedError;
  User get author => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  int get likes => throw _privateConstructorUsedError;
  int get numReplies => throw _privateConstructorUsedError;
  String get replyToId => throw _privateConstructorUsedError;
  bool get likedByUser => throw _privateConstructorUsedError;

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
      {AtUri uri,
      String cid,
      User author,
      String content,
      DateTime timestamp,
      int likes,
      int numReplies,
      String replyToId,
      bool likedByUser});

  $UserCopyWith<$Res> get author;
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
    Object? uri = null,
    Object? cid = null,
    Object? author = null,
    Object? content = null,
    Object? timestamp = null,
    Object? likes = null,
    Object? numReplies = null,
    Object? replyToId = null,
    Object? likedByUser = null,
  }) {
    return _then(_value.copyWith(
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as AtUri,
      cid: null == cid
          ? _value.cid
          : cid // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as User,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      numReplies: null == numReplies
          ? _value.numReplies
          : numReplies // ignore: cast_nullable_to_non_nullable
              as int,
      replyToId: null == replyToId
          ? _value.replyToId
          : replyToId // ignore: cast_nullable_to_non_nullable
              as String,
      likedByUser: null == likedByUser
          ? _value.likedByUser
          : likedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get author {
    return $UserCopyWith<$Res>(_value.author, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
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
      {AtUri uri,
      String cid,
      User author,
      String content,
      DateTime timestamp,
      int likes,
      int numReplies,
      String replyToId,
      bool likedByUser});

  @override
  $UserCopyWith<$Res> get author;
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
    Object? uri = null,
    Object? cid = null,
    Object? author = null,
    Object? content = null,
    Object? timestamp = null,
    Object? likes = null,
    Object? numReplies = null,
    Object? replyToId = null,
    Object? likedByUser = null,
  }) {
    return _then(_$ReplyImpl(
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as AtUri,
      cid: null == cid
          ? _value.cid
          : cid // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as User,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      numReplies: null == numReplies
          ? _value.numReplies
          : numReplies // ignore: cast_nullable_to_non_nullable
              as int,
      replyToId: null == replyToId
          ? _value.replyToId
          : replyToId // ignore: cast_nullable_to_non_nullable
              as String,
      likedByUser: null == likedByUser
          ? _value.likedByUser
          : likedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ReplyImpl implements _Reply {
  const _$ReplyImpl(
      {required this.uri,
      required this.cid,
      required this.author,
      required this.content,
      required this.timestamp,
      required this.likes,
      required this.numReplies,
      required this.replyToId,
      required this.likedByUser});

  @override
  final AtUri uri;
  @override
  final String cid;
  @override
  final User author;
  @override
  final String content;
  @override
  final DateTime timestamp;
  @override
  final int likes;
  @override
  final int numReplies;
  @override
  final String replyToId;
  @override
  final bool likedByUser;

  @override
  String toString() {
    return 'Reply(uri: $uri, cid: $cid, author: $author, content: $content, timestamp: $timestamp, likes: $likes, numReplies: $numReplies, replyToId: $replyToId, likedByUser: $likedByUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReplyImpl &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.numReplies, numReplies) ||
                other.numReplies == numReplies) &&
            (identical(other.replyToId, replyToId) ||
                other.replyToId == replyToId) &&
            (identical(other.likedByUser, likedByUser) ||
                other.likedByUser == likedByUser));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uri, cid, author, content,
      timestamp, likes, numReplies, replyToId, likedByUser);

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReplyImplCopyWith<_$ReplyImpl> get copyWith =>
      __$$ReplyImplCopyWithImpl<_$ReplyImpl>(this, _$identity);
}

abstract class _Reply implements Reply {
  const factory _Reply(
      {required final AtUri uri,
      required final String cid,
      required final User author,
      required final String content,
      required final DateTime timestamp,
      required final int likes,
      required final int numReplies,
      required final String replyToId,
      required final bool likedByUser}) = _$ReplyImpl;

  @override
  AtUri get uri;
  @override
  String get cid;
  @override
  User get author;
  @override
  String get content;
  @override
  DateTime get timestamp;
  @override
  int get likes;
  @override
  int get numReplies;
  @override
  String get replyToId;
  @override
  bool get likedByUser;

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReplyImplCopyWith<_$ReplyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
