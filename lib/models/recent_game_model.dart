class RecentGameModel {
  final String name;
  final String icon;
  final String url;
  final DateTime lastPlayed;
  final int sessionMinutes;
  final bool canResume;

  RecentGameModel({
    required this.name,
    required this.icon,
    required this.url,
    required this.lastPlayed,
    required this.sessionMinutes,
    this.canResume = false,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(lastPlayed);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hrs ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  String get sessionTime {
    if (sessionMinutes < 60) {
      return '${sessionMinutes} mins';
    } else {
      final hours = sessionMinutes ~/ 60;
      final mins = sessionMinutes % 60;
      return '${hours}h ${mins}m';
    }
  }
}