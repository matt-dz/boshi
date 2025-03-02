String timeSincePosting(DateTime time) {
  final currentTime = DateTime.now().toUtc();
  final timeDifference = currentTime.difference(time.toUtc());

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
