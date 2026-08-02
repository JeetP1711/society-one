import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/complaint_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

class ComplaintDetailScreen extends ConsumerStatefulWidget {
  final Complaint complaint;

  const ComplaintDetailScreen({super.key, required this.complaint});

  @override
  ConsumerState<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends ConsumerState<ComplaintDetailScreen> {
  final _commentController = TextEditingController();

  void _showStatusDialog(BuildContext context, Complaint currentTicket) {
    final techController =
        TextEditingController(text: currentTicket.assignedTechnician ?? '');
    ComplaintStatus selectedStatus = currentTicket.status;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            'Update Ticket Status',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ComplaintStatus>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ComplaintStatus.values
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.name.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (val) => setDialogState(() => selectedStatus = val!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: techController,
                decoration: const InputDecoration(
                  labelText: 'Assigned Technician Name/Phone',
                  hintText: 'e.g. Ramesh Plumber (+91 98999 11111)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(complaintProvider.notifier).updateComplaintStatus(
                      currentTicket.id,
                      selectedStatus,
                      technicianName: techController.text.trim().isEmpty
                          ? null
                          : techController.text.trim(),
                    );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ticket status updated!')),
                );
              },
              child: const Text('UPDATE'),
            ),
          ],
        ),
      ),
    );
  }

  void _postComment(Complaint currentTicket) {
    if (_commentController.text.trim().isEmpty) return;

    final user = ref.read(authProvider).currentUser;
    ref.read(complaintProvider.notifier).addComment(
          currentTicket.id,
          user?.fullName ?? 'User',
          user?.role.displayName ?? 'Resident',
          _commentController.text.trim(),
        );

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final complaintsList = ref.watch(complaintProvider);
    final currentTicket = complaintsList.firstWhere(
      (c) => c.id == widget.complaint.id,
      orElse: () => widget.complaint,
    );

    final currentUser = ref.watch(authProvider).currentUser;
    final isSecretary = currentUser?.role == UserRole.secretary ||
        currentUser?.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticket Details',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (isSecretary)
            IconButton(
              icon: const Icon(Icons.edit_note),
              onPressed: () => _showStatusDialog(context, currentTicket),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ticket Main Card
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Category: ${currentTicket.category.name.toUpperCase()}',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                currentTicket.status.name.toUpperCase(),
                                style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currentTicket.title,
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentTicket.description,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Raised by: Flat ${currentTicket.flatNumber}',
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy, hh:mm a')
                                  .format(currentTicket.createdAt),
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                          ],
                        ),
                        if (currentTicket.assignedTechnician != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.handyman,
                                    size: 16, color: AppColors.info),
                                const SizedBox(width: 8),
                                Text(
                                  'Technician: ${currentTicket.assignedTechnician}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.info,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Status Timeline Section
                  Text(
                    'Status Timeline',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...currentTicket.timeline.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.title,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    entry.description,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd MMM, hh:mm a')
                                        .format(entry.timestamp),
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 24),

                  // Discussion Thread
                  Text(
                    'Discussion Thread (${currentTicket.comments.length})',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...currentTicket.comments.map((comment) => GlassCard(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${comment.authorName} (${comment.authorRole})',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('hh:mm a').format(comment.timestamp),
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment.message,
                              style: GoogleFonts.inter(fontSize: 13),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),

          // Comment Input Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Type a discussion comment...',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: () => _postComment(currentTicket),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
