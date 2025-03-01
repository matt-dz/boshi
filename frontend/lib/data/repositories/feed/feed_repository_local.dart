import 'package:frontend/utils/result.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/data/repositories/feed/feed_repository.dart';
import 'package:frontend/data/services/local/local_data_service.dart';

class FeedRepositoryLocal extends FeedRepository {
  FeedRepositoryLocal({required LocalDataService localDataService})
      : _localDataService = localDataService;

  final LocalDataService _localDataService;

  @override
  Future<Result<List<Post>>> getFeed() async {
    return Result.ok(_localDataService.getFeed());
  }
}
