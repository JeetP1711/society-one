import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/announcement_model.dart';
import '../models/complaint_model.dart';
import 'mock_data.dart';

class ComplaintNotifier extends StateNotifier<List<Complaint>> {
  ComplaintNotifier() : super(MockData.initialComplaints);

  void createComplaint({
    required String title,
    required String description,
    required ComplaintCategory category,
    required PriorityLevel priority,
    required String createdBy,
    required String flatNumber,
  }) {
    final now = DateTime.now();
    final newComplaint = Complaint(
      id: const Uuid().v4(),
      title: title,
      description: description,
      category: category,
      priority: priority,
      status: ComplaintStatus.open,
      createdBy: createdBy,
      flatNumber: flatNumber,
      createdAt: now,
      timeline: [
        TimelineEntry(
          title: 'Ticket Raised',
          description: 'Complaint submitted by $createdBy',
          timestamp: now,
        ),
      ],
      comments: [],
    );

    state = [newComplaint, ...state];
  }

  void updateComplaintStatus(String id, ComplaintStatus newStatus, {String? technicianName}) {
    final now = DateTime.now();
    state = state.map((c) {
      if (c.id == id) {
        String statusLabel = 'Status Updated';
        String statusDesc = 'Status changed to ${newStatus.name}';
        if (newStatus == ComplaintStatus.inProgress) {
          statusLabel = 'In Progress';
          statusDesc = technicianName != null
              ? 'Assigned to technician: $technicianName'
              : 'Work started on complaint';
        } else if (newStatus == ComplaintStatus.resolved) {
          statusLabel = 'Resolved';
          statusDesc = 'Issue has been marked resolved';
        }

        final newTimeline = [
          ...c.timeline,
          TimelineEntry(
            title: statusLabel,
            description: statusDesc,
            timestamp: now,
          )
        ];

        return c.copyWith(
          status: newStatus,
          assignedTechnician: technicianName ?? c.assignedTechnician,
          timeline: newTimeline,
        );
      }
      return c;
    }).toList();
  }

  void addComment(String complaintId, String authorName, String authorRole, String message) {
    state = state.map((c) {
      if (c.id == complaintId) {
        final comment = ComplaintComment(
          id: const Uuid().v4(),
          authorName: authorName,
          authorRole: authorRole,
          message: message,
          timestamp: DateTime.now(),
        );
        return c.copyWith(
          comments: [...c.comments, comment],
        );
      }
      return c;
    }).toList();
  }
}

final complaintProvider =
    StateNotifierProvider<ComplaintNotifier, List<Complaint>>((ref) {
  return ComplaintNotifier();
});
