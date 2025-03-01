import 'package:frontend/utils/result.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/data/repositories/feed/feed_repository.dart';
import 'package:frontend/data/services/api/api_client.dart';

class FeedRepositoryRemote extends FeedRepository {
  FeedRepositoryRemote({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  // TODO: Implement the getFeed method
  @override
  Future<Result<List<Post>>> getFeed() async {
    return await _apiClient.getFeed();
}
