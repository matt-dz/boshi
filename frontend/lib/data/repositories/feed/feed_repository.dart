import 'package:frontend/utils/result.dart';

import 'package:frontend/shared/models/report/report.dart';
import 'package:frontend/shared/models/reaction_payload/reaction_payload.dart';

import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/data/models/requests/reply/reply.dart'
    as reply_request;
import 'package:frontend/data/models/requests/post/post.dart' as post_request;

/// Retrieves and formats data from the feed service
abstract class FeedRepository {
  Future<Result<List<Post>>> getFeed();
  Future<Result<Post>> updateReactionCount(ReactionPayload reactionPayload);
  Future<Result<Post>> getPost(String id);
  Future<Result<Post>> addPost(post_request.Post post);
  Future<Result<Post>> addReply(reply_request.Reply reply);
  Future<Result<void>> reportPost(Report report);
}
