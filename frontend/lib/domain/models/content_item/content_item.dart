import 'package:frontend/domain/models/user/user.dart';

abstract class ContentItem {
  const ContentItem({
    required this.id,
    required this.timestamp,
    required this.author,
    required this.reactions,
    required this.content,
    required this.comments,
  });

  final String id;
  final DateTime timestamp;
  final User author;
  final Set<String> reactions;
  final List<ContentItem> comments;
  final String content;
}
