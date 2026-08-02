import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/announcement_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/announcement_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/priority_chip.dart';
import 'meeting_detail_screen.dart';

class AnnouncementsScreen extends ConsumerStatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  ConsumerState<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends ConsumerState<AnnouncementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  NoticeCategory? _selectedCategory;
  PriorityLevel? _selectedPriority;

  @override
  void initState() {
    super.initState()
    _tabController = TabController(length: 2, vsync: this);
  }

  void _showNewAnnouncementDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    NoticeCategory category = NoticeCategory.general;
    PriorityLevel priority = PriorityLevel.medium;
    final user = ref.read(authProvider).currentUser;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setBottomSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Post New Announcement',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Content Details'),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<NoticeCategory>(
                      value: category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: NoticeCategory.values
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.name.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (v) => setBottomSheetState(() => category = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<PriorityLevel>(
                      value: priority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: PriorityLevel.values
                          .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text(p.name.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (v) => setBottomSheetState(() => priority = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    ref.read(announcementProvider.notifier).addAnnouncement(
                          title: titleController.text.trim(),
                          content: contentController.text.trim(),
                          priority: priority,
                          category: category,
                          authorName: user?.fullName ?? 'Secretary',
                        );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Announcement posted successfully!')),
                    );
                  }
                },
                child: const Text('POST NOTICE'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final announcements = ref.watch(announcementProvider);
    final meetings = ref.watch(meetingProvider);
    final currentUser = ref.watch(authProvider).currentUser;
    final isSecretary = currentUser?.role == UserRole.secretary ||
        currentUser?.role == UserRole.admin;

    final filteredNotices = announcements.where((a) {
      if (_selectedCategory != null && a.category != _selectedCategory) {
        return false;
      }
      if (_selectedPriority != null && a.priority != _selectedPriority) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notice Board & Meetings',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Notices'),
            Tab(text: 'AGM & Meetings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Notices Tab
          Column(
            children: [
              // Filter Bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Categories'),
                      selected: _selectedCategory == null,
                      onSelected: (_) => setState(() => _selectedCategory = null),
                    ),
                    const SizedBox(width: 8),
                    ...NoticeCategory.values.map((cat) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cat.name.toUpperCase()),
                            selected: _selectedCategory == cat,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected ? cat : null;
                              });
                            },
                          ),
                        )),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredNotices.length,
                  itemBuilder: (context, index) {
                    final notice = filteredNotices[index];
                    return GlassCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              PriorityChip(priority: notice.priority),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  notice.category.name.toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              if (notice.isPinned)
                                const Icon(Icons.push_pin,
                                    size: 16, color: AppColors.warning),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            notice.title,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            notice.content,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'By: ${notice.authorName}',
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                              Text(
                                DateFormat('dd MMM yyyy').format(notice.createdAt),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Meetings Tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: meetings.length,
            itemBuilder: (context, index) {
              final meeting = meetings[index];
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MeetingDetailScreen(meeting: meeting),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.event, color: AppColors.secondary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meeting.title,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('EEE, dd MMM yyyy • hh:mm a')
                                    .format(meeting.dateTime),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      meeting.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              meeting.venue,
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                          ],
                        ),
                        Text(
                          'RSVP Now →',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: isSecretary
          ? FloatingActionButton(
              onPressed: _showNewAnnouncementDialog,
              child: const Icon(Icons.post_add),
            )
          : null,
    );
  }
}
