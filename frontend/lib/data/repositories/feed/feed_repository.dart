import 'package:frontend/utils/result.dart';
import 'package:frontend/domain/models/post/post.dart';

/// Retrieves and formats data from the feed service
abstract class FeedRepository {
  Future<Result<List<Post>>> getFeed();
}
