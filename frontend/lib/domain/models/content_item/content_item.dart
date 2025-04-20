import 'package:frontend/domain/models/user/user.dart';

abstract class ContentItem {
  const ContentItem({
    required this.id,
    required this.timestamp,
    required this.author,
    required this.likes,
    required this.content,
    required this.numReplies,
  });

  final String id;
  final DateTime timestamp;
  final User author;
  final int likes;
  final int numReplies;
  final String content;
}
