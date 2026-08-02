import 'announcement_model.dart';

enum ComplaintCategory { plumbing, electrical, cleanliness, security, other }
enum ComplaintStatus { open, inProgress, resolved, closed }

class TimelineEntry {
  final String title;
  final String description;
  final DateTime timestamp;

  const TimelineEntry({
    required this.title,
    required this.description,
    required this.timestamp,
  });
}

class ComplaintComment {
  final String id;
  final String authorName;
  final String authorRole;
  final String message;
  final DateTime timestamp;

  const ComplaintComment({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.message,
    required this.timestamp,
  });
}

class Complaint {
  final String id;
  final String title;
  final String description;
  final ComplaintCategory category;
  final PriorityLevel priority;
  final ComplaintStatus status;
  final String createdBy;
  final String flatNumber;
  final DateTime createdAt;
  final String? assignedTechnician;
  final List<TimelineEntry> timeline;
  final List<ComplaintComment> comments;

  const Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdBy,
    required this.flatNumber,
    required this.createdAt,
    this.assignedTechnician,
    required this.timeline,
    required this.comments,
  });

  Complaint copyWith({
    String? id,
    String? title,
    String? description,
    ComplaintCategory? category,
    PriorityLevel? priority,
    ComplaintStatus? status,
    String? createdBy,
    String? flatNumber,
    DateTime? createdAt,
    String? assignedTechnician,
    List<TimelineEntry>? timeline,
    List<ComplaintComment>? comments,
  }) {
    return Complaint(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      flatNumber: flatNumber ?? this.flatNumber,
      createdAt: createdAt ?? this.createdAt,
      assignedTechnician: assignedTechnician ?? this.assignedTechnician,
      timeline: timeline ?? this.timeline,
      comments: comments ?? this.comments,
    );
  }
}
