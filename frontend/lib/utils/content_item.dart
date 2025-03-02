import 'package:frontend/domain/models/content_item/content_item.dart';

String timeSincePosting(ContentItem contentItem) {
  final currentTime = DateTime.now().toUtc();
  final timeDifference = currentTime.difference(contentItem.timestamp.toUtc());

  if (timeDifference.inDays >= 7) {
    return '${timeDifference.inDays ~/ 7}w';
  } else if (timeDifference.inDays >= 1) {
    return '${timeDifference.inDays}d';
  } else if (timeDifference.inHours >= 1) {
    return '${timeDifference.inHours}h';
  } else if (timeDifference.inMinutes >= 1) {
    return '${timeDifference.inMinutes}m';
  } else {
    return '${timeDifference.inSeconds}s';
  }
}
