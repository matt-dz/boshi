import 'dart:io';

import 'package:frontend/utils/result.dart';
import 'package:frontend/config/environment.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';

class LocalDataService {
  List<Post> getFeed() {
    return [
      Post(
        author: User(
          id: '1',
          username: 'anonymous1',
          school: 'University of Florida',
        ),
        content: 'Hello, world!',
        timestamp: DateTime.now(),
        reactions: [],
        comments: [],
      ),
      Post(
        author: User(
          id: '2',
          username: 'anonymous2',
          school: 'Stanford University',
        ),
        content: '''
        Lorem ipsum dolor sit amet, consectetur adipiscing
        elit, sed do eiusmod tempor incididunt ut labore et
        dolore magna aliqua.
        ''',
        timestamp: DateTime.now(),
        reactions: [],
        comments: [],
      ),
      Post(
        author: User(
          id: '3',
          username: 'anonymous3',
          school: 'University of Washington',
        ),
        content: '''
        Lorem ipsum dolor sit amet, consectetur
        adipiscing elit, sed do eiusmod tempor
        incididunt ut labore et dolore magna aliqua. Ut
        enim ad minim veniam, quis nostrud exercitation
        ullamco laboris nisi ut aliquip ex ea commodo
        consequat.
        ''',
        timestamp: DateTime.now(),
        reactions: [],
        comments: [],
      ),
      Post(
        author: User(
          id: '4',
          username: 'anonymous4',
          school: 'Princeton University',
        ),
        content: '''
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        ''',
        timestamp: DateTime.now(),
        reactions: [],
        comments: [],
      ),
      Post(
        author: User(
          id: '5',
          username: 'anonymous5',
          school: 'Harvard University',
        ),
        content: '''
        Lorem ipsum dolor sit amet, consectetur adipiscing
        elit, sed do eiusmod tempor incididunt ut labore et
        dolore magna aliqua.
        ''',
        timestamp: DateTime.now(),
        reactions: [],
        comments: [],
      ),
      Post(
        author: User(
          id: '6',
          username: 'anonymous6',
          school: 'University of California, Berkely',
        ),
        content: '''
        Lorem ipsum dolor sit amet, consectetur adipiscing
        elit, sed do eiusmod tempor incididunt ut labore et
        dolore magna aliqua.
        ''',
        timestamp: DateTime.now(),
        reactions: [],
        comments: [],
      ),
      Post(
        author: User(
          id: '7',
          username: 'anonymous7',
          school: 'University of Southern California',
        ),
        content: '''
        Lorem ipsum dolor sit amet, consectetur adipiscing
        elit, sed do eiusmod tempor incididunt ut labore et
        dolore magna aliqua.
        ''',
        timestamp: DateTime.now(),
        reactions: [],
        comments: [],
      ),
      Post(
        author: User(
          id: '8',
          username: 'anonymous8',
          school: 'University of California, Los Angeles',
        ),
        content: '''
        Lorem ipsum dolor sit amet, consectetur adipiscing
        elit, sed do eiusmod tempor incididunt ut labore et
        dolore magna aliqua.
        ''',
        timestamp: DateTime.now(),
        reactions: [],
        comments: [],
      ),
      Post(
        author: User(
          id: '9',
          username: 'anonymous9',
          school: 'University of Pennsylvania',
        ),
        content: '''
        Lorem ipsum dolor sit amet, consectetur adipiscing
        elit, sed do eiusmod tempor incididunt ut labore et
        dolore magna aliqua.
        ''',
        timestamp: DateTime.now(),
        reactions: [],
        comments: [],
      ),
      Post(
        author: User(
          id: '10',
          username: 'anonymous10',
          school: 'Massachusetts Institute of Technology',
        ),
        content: '''
        Lorem ipsum dolor sit amet, consectetur adipiscing
        elit, sed do eiusmod tempor incididunt ut labore et
        dolore magna aliqua.
        ''',
        timestamp: DateTime.now(),
        reactions: [],
        comments: [],
      ),
    ];
  }
}
