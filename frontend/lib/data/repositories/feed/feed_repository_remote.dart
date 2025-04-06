import 'package:frontend/utils/result.dart';

import 'package:frontend/shared/models/reaction_payload/reaction_payload.dart';

import 'package:frontend/domain/models/post/post.dart' as post_domain_model;

import 'package:frontend/shared/models/report/report.dart';

import 'package:frontend/data/services/api/api_client.dart';
import 'package:frontend/data/models/requests/reply/reply.dart'
    as reply_request;

import 'feed_repository.dart';

class FeedRepositoryRemote implements FeedRepository {
  FeedRepositoryRemote({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  // TODO: Implement the getFeed method
  @override
  Future<Result<List<post_domain_model.Post>>> getFeed() async {
    return _apiClient.getFeed();
  }

  @override
  Future<Result<post_domain_model.Post>> updateReactionCount(
    ReactionPayload reactionPayload,
  ) async {
    return _apiClient.updateReactionCount(reactionPayload);
  }

  @override
  Future<Result<post_domain_model.Post>> getPost(String id) async {
    return _apiClient.getPost(id);
  }

  @override
  Future<Result<post_domain_model.Post>> createReply(
    reply_request.Reply reply,
  ) async {
    return _apiClient.addReply(reply);
  }

  @override
  Future<Result<void>> reportPost(Report report) async {
    return _apiClient.reportPost(report);
  }
}
