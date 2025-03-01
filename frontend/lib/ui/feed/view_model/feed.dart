/* Retrieve feed from the feed repository */
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/data/repositories/feed/feed_repository.dart';

class FeedViewModel extends ChangeNotifier {
  FeedViewModel({
    required FeedRepository feedRepository,
  }) : _feedRepository = feedRepository;

  final FeedRepository _feedRepository;

  List<Post> _posts = [];

  UnmodifiableListView<Post> get posts => UnmodifiableListView(_posts);
}
