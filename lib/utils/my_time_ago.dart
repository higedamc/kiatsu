// 秒を日、時間、分、秒に変換
String myTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final sec = difference.inSeconds;

    if (sec >= 60 * 60 * 24) {
      return '最終更新 - ${difference.inDays.toString()}日前';
    } else if (sec >= 60 * 60) {
      return '最終更新 - ${difference.inHours.toString()}時間前';
    } else if (sec >= 60) {
      return '最終更新 - ${difference.inMinutes.toString()}分前';
    } else {
      return '最終更新 - $sec秒前';
    }
  }