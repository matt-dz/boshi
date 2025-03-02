import 'package:frontend/utils/result.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/data/services/local/local_data_service.dart';

import 'feed_repository.dart';

class FeedRepositoryLocal implements FeedRepository {
  FeedRepositoryLocal({required LocalDataService localDataService})
      : _localDataService = localDataService;

  final LocalDataService _localDataService;

  @override
  Future<Result<List<Post>>> getFeed() async {
    return _localDataService.getFeed();
  }
}
