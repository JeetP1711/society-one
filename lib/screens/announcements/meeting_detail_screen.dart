import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/meeting_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/announcement_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

class MeetingDetailScreen extends ConsumerWidget {
  final Meeting meeting;

  const MeetingDetailScreen({super.key, required this.meeting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetings = ref.watch(meetingProvider);
    final currentMeeting =
        meetings.firstWhere((m) => m.id == meeting.id, orElse: () => meeting);
    final user = ref.watch(authProvider).currentUser;
    final userId = user?.id ?? '';
    final rsvpStatus = currentMeeting.rsvps[userId];

    final attendingCount =
        currentMeeting.rsvps.values.where((status) => status == true).length;
    final declinedCount =
        currentMeeting.rsvps.values.where((status) => status == false).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meeting Details',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentMeeting.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time_filled,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('EEEE, dd MMMM yyyy • hh:mm a')
                            .format(currentMeeting.dateTime),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: AppColors.secondary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        currentMeeting.venue,
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentMeeting.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Interactive RSVP Card
            Text(
              'Your Attendance RSVP',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: rsvpStatus == true
                                ? AppColors.success.withOpacity(0.2)
                                : null,
                            side: BorderSide(
                              color: rsvpStatus == true
                                  ? AppColors.success
                                  : Theme.of(context).dividerColor,
                            ),
                          ),
                          onPressed: () {
                            ref
                                .read(meetingProvider.notifier)
                                .toggleRsvp(currentMeeting.id, userId, true);
                          },
                          icon: Icon(
                            Icons.check_circle,
                            color: rsvpStatus == true
                                ? AppColors.success
                                : Colors.grey,
                          ),
                          label: Text(
                            'ATTENDING',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: rsvpStatus == true
                                  ? AppColors.success
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: rsvpStatus == false
                                ? AppColors.danger.withOpacity(0.2)
                                : null,
                            side: BorderSide(
                              color: rsvpStatus == false
                                  ? AppColors.danger
                                  : Theme.of(context).dividerColor,
                            ),
                          ),
                          onPressed: () {
                            ref
                                .read(meetingProvider.notifier)
                                .toggleRsvp(currentMeeting.id, userId, false);
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: rsvpStatus == false
                                ? AppColors.danger
                                : Colors.grey,
                          ),
                          label: Text(
                            'DECLINE',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: rsvpStatus == false
                                  ? AppColors.danger
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Confirmed Attending: $attendingCount',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Declined: $declinedCount',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.danger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Meeting Agenda Items
            Text(
              'Meeting Agenda & Topics',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...currentMeeting.agendaItems.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final item = entry.value;
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        '$idx',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
