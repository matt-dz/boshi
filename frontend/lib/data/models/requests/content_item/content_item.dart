abstract class ContentItem {
  const ContentItem({
    required this.authorId,
    required this.content,
    required this.title,
  });

  final String authorId;
  final String title;
  final String content;
}
