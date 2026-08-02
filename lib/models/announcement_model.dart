enum PriorityLevel { urgent, high, medium, low }
enum NoticeCategory { maintenance, general, event, emergency }

class Announcement {
  final String id;
  final String title;
  final String content;
  final PriorityLevel priority;
  final NoticeCategory category;
  final DateTime createdAt;
  final String authorName;
  final bool isPinned;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.category,
    required this.createdAt,
    required this.authorName,
    this.isPinned = false,
  });
}
