import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/announcement_model.dart';
import '../models/meeting_model.dart';
import 'mock_data.dart';

class AnnouncementNotifier extends StateNotifier<List<Announcement>> {
  AnnouncementNotifier() : super(MockData.initialAnnouncements);

  void addAnnouncement({
    required String title,
    required String content,
    required PriorityLevel priority,
    required NoticeCategory category,
    required String authorName,
    bool isPinned = false,
  }) {
    final newAnnouncement = Announcement(
      id: const Uuid().v4(),
      title: title,
      content: content,
      priority: priority,
      category: category,
      createdAt: DateTime.now(),
      authorName: authorName,
      isPinned: isPinned,
    );

    if (isPinned) {
      state = [newAnnouncement, ...state];
    } else {
      state = [...state, newAnnouncement];
    }
  }
}

final announcementProvider =
    StateNotifierProvider<AnnouncementNotifier, List<Announcement>>((ref) {
  return AnnouncementNotifier();
});

class MeetingNotifier extends StateNotifier<List<Meeting>> {
  MeetingNotifier() : super(MockData.initialMeetings);

  void toggleRsvp(String meetingId, String userId, bool isAttending) {
    state = state.map((m) {
      if (m.id == meetingId) {
        final updatedRsvps = Map<String, bool>.from(m.rsvps);
        updatedRsvps[userId] = isAttending;
        return m.copyWith(rsvps: updatedRsvps);
      }
      return m;
    }).toList();
  }

  void addMeeting({
    required String title,
    required String description,
    required DateTime dateTime,
    required String venue,
    required List<String> agendaItems,
  }) {
    final meeting = Meeting(
      id: const Uuid().v4(),
      title: title,
      description: description,
      dateTime: dateTime,
      venue: venue,
      agendaItems: agendaItems,
      rsvps: {},
    );
    state = [meeting, ...state];
  }
}

final meetingProvider = StateNotifierProvider<MeetingNotifier, List<Meeting>>((ref) {
  return MeetingNotifier();
});
