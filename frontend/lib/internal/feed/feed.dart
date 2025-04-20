import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/domain/models/users/users.dart';
import 'package:frontend/internal/result/result.dart';

Future<Result<List<Post>>> convertFeedToDomainPosts(
  AtProtoRepository atproto,
  bsky.Feed feed,
) async {
  final userDids =
      feed.feed.map((post) => post.post.author.did).toSet().toList();

  final usersResponse = await atproto.getUsers(userDids);
  final Users users;
  switch (usersResponse) {
    case Ok<Users>():
      users = usersResponse.value;
    case Error<Users>():
      return Result.error(usersResponse.error);
  }

  return Result.ok(
    feed.feed.map((feedView) {
      final titleEnd = feedView.post.record.facets?[0].index.byteEnd;

      final title = feedView.post.record.text.substring(0, titleEnd);
      final content = feedView.post.record.text
          .substring(titleEnd == null ? 0 : titleEnd + 1);

      return Post(
        id: feedView.post.cid,
        author: User(
          id: feedView.post.author.did,
          school: users.users
              .firstWhere(
                (user) => user.id == feedView.post.author.did,
                orElse: () => User(id: 'unknown', school: 'unknown'),
              )
              .school,
        ),
        title: title,
        content: content,
        timestamp: feedView.post.indexedAt,
        reactions: List.empty(),
        comments: List.empty(),
      );
    }).toList(),
  );
}
