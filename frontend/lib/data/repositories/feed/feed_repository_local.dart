import 'package:frontend/shared/models/report/report.dart';
import 'package:frontend/data/services/local/local_data_service.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/domain/models/post/post.dart' as post_domain_model;
import 'package:frontend/data/models/requests/reply/reply.dart'
    as reply_request;
import 'package:frontend/shared/models/reaction_payload/reaction_payload.dart';

import 'feed_repository.dart';

class FeedRepositoryLocal implements FeedRepository {
  FeedRepositoryLocal({required LocalDataService localDataService})
      : _localDataService = localDataService;

  final LocalDataService _localDataService;

  @override
  Future<Result<List<post_domain_model.Post>>> getFeed() async {
    return _localDataService.getFeed();
  }

  @override
  Future<Result<post_domain_model.Post>> updateReactionCount(
    ReactionPayload reactionPayload,
  ) async {
    return _localDataService.updateReactionCount(reactionPayload);
  }

  @override
  Future<Result<post_domain_model.Post>> getPost(String id) async {
    return _localDataService.getPost(id);
  }

  @override
  Future<Result<post_domain_model.Post>> createReply(
    reply_request.Reply reply,
  ) async {
    return _localDataService.addReply(reply);
  }

  @override
  Future<Result<void>> reportPost(Report report) async {
    return _localDataService.reportPost(report);
  }
}
