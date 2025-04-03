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
  String get id => throw _privateConstructorUsedError;
  User get author => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  List<Reaction> get reactions => throw _privateConstructorUsedError;
  List<Reply> get comments => throw _privateConstructorUsedError;
  String get replyToId => throw _privateConstructorUsedError;

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
      {String id,
      User author,
      String content,
      DateTime timestamp,
      List<Reaction> reactions,
      List<Reply> comments,
      String replyToId});

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
    Object? id = null,
    Object? author = null,
    Object? content = null,
    Object? timestamp = null,
    Object? reactions = null,
    Object? comments = null,
    Object? replyToId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      reactions: null == reactions
          ? _value.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<Reaction>,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Reply>,
      replyToId: null == replyToId
          ? _value.replyToId
          : replyToId // ignore: cast_nullable_to_non_nullable
              as String,
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
      {String id,
      User author,
      String content,
      DateTime timestamp,
      List<Reaction> reactions,
      List<Reply> comments,
      String replyToId});

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
    Object? id = null,
    Object? author = null,
    Object? content = null,
    Object? timestamp = null,
    Object? reactions = null,
    Object? comments = null,
    Object? replyToId = null,
  }) {
    return _then(_$ReplyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      reactions: null == reactions
          ? _value._reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<Reaction>,
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<Reply>,
      replyToId: null == replyToId
          ? _value.replyToId
          : replyToId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReplyImpl implements _Reply {
  const _$ReplyImpl(
      {required this.id,
      required this.author,
      required this.content,
      required this.timestamp,
      required final List<Reaction> reactions,
      required final List<Reply> comments,
      required this.replyToId})
      : _reactions = reactions,
        _comments = comments;

  factory _$ReplyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReplyImplFromJson(json);

  @override
  final String id;
  @override
  final User author;
  @override
  final String content;
  @override
  final DateTime timestamp;
  final List<Reaction> _reactions;
  @override
  List<Reaction> get reactions {
    if (_reactions is EqualUnmodifiableListView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reactions);
  }

  final List<Reply> _comments;
  @override
  List<Reply> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  final String replyToId;

  @override
  String toString() {
    return 'Reply(id: $id, author: $author, content: $content, timestamp: $timestamp, reactions: $reactions, comments: $comments, replyToId: $replyToId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReplyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other._reactions, _reactions) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            (identical(other.replyToId, replyToId) ||
                other.replyToId == replyToId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      author,
      content,
      timestamp,
      const DeepCollectionEquality().hash(_reactions),
      const DeepCollectionEquality().hash(_comments),
      replyToId);

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
      {required final String id,
      required final User author,
      required final String content,
      required final DateTime timestamp,
      required final List<Reaction> reactions,
      required final List<Reply> comments,
      required final String replyToId}) = _$ReplyImpl;

  factory _Reply.fromJson(Map<String, dynamic> json) = _$ReplyImpl.fromJson;

  @override
  String get id;
  @override
  User get author;
  @override
  String get content;
  @override
  DateTime get timestamp;
  @override
  List<Reaction> get reactions;
  @override
  List<Reply> get comments;
  @override
  String get replyToId;

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReplyImplCopyWith<_$ReplyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
