// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Post {
  String get title => throw _privateConstructorUsedError;
  AtUri get uri => throw _privateConstructorUsedError;
  String get cid => throw _privateConstructorUsedError;
  User get author => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  int get likes => throw _privateConstructorUsedError;
  int get numReplies => throw _privateConstructorUsedError;
  bool get likedByUser => throw _privateConstructorUsedError;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCopyWith<Post> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) then) =
      _$PostCopyWithImpl<$Res, Post>;
  @useResult
  $Res call(
      {String title,
      AtUri uri,
      String cid,
      User author,
      String content,
      DateTime timestamp,
      int likes,
      int numReplies,
      bool likedByUser});

  $UserCopyWith<$Res> get author;
}

/// @nodoc
class _$PostCopyWithImpl<$Res, $Val extends Post>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? uri = null,
    Object? cid = null,
    Object? author = null,
    Object? content = null,
    Object? timestamp = null,
    Object? likes = null,
    Object? numReplies = null,
    Object? likedByUser = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
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
      likedByUser: null == likedByUser
          ? _value.likedByUser
          : likedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of Post
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
abstract class _$$PostImplCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$$PostImplCopyWith(
          _$PostImpl value, $Res Function(_$PostImpl) then) =
      __$$PostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      AtUri uri,
      String cid,
      User author,
      String content,
      DateTime timestamp,
      int likes,
      int numReplies,
      bool likedByUser});

  @override
  $UserCopyWith<$Res> get author;
}

/// @nodoc
class __$$PostImplCopyWithImpl<$Res>
    extends _$PostCopyWithImpl<$Res, _$PostImpl>
    implements _$$PostImplCopyWith<$Res> {
  __$$PostImplCopyWithImpl(_$PostImpl _value, $Res Function(_$PostImpl) _then)
      : super(_value, _then);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? uri = null,
    Object? cid = null,
    Object? author = null,
    Object? content = null,
    Object? timestamp = null,
    Object? likes = null,
    Object? numReplies = null,
    Object? likedByUser = null,
  }) {
    return _then(_$PostImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
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
      likedByUser: null == likedByUser
          ? _value.likedByUser
          : likedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PostImpl implements _Post {
  const _$PostImpl(
      {required this.title,
      required this.uri,
      required this.cid,
      required this.author,
      required this.content,
      required this.timestamp,
      required this.likes,
      required this.numReplies,
      required this.likedByUser});

  @override
  final String title;
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
  final bool likedByUser;

  @override
  String toString() {
    return 'Post(title: $title, uri: $uri, cid: $cid, author: $author, content: $content, timestamp: $timestamp, likes: $likes, numReplies: $numReplies, likedByUser: $likedByUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.numReplies, numReplies) ||
                other.numReplies == numReplies) &&
            (identical(other.likedByUser, likedByUser) ||
                other.likedByUser == likedByUser));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, uri, cid, author, content,
      timestamp, likes, numReplies, likedByUser);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      __$$PostImplCopyWithImpl<_$PostImpl>(this, _$identity);
}

abstract class _Post implements Post {
  const factory _Post(
      {required final String title,
      required final AtUri uri,
      required final String cid,
      required final User author,
      required final String content,
      required final DateTime timestamp,
      required final int likes,
      required final int numReplies,
      required final bool likedByUser}) = _$PostImpl;

  @override
  String get title;
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
  bool get likedByUser;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
