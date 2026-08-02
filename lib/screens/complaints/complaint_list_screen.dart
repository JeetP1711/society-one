import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/complaint_model.dart';
import '../../providers/complaint_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/priority_chip.dart';
import '../../widgets/empty_state.dart';
import 'complaint_detail_screen.dart';
import 'complaint_form_screen.dart';

class ComplaintListScreen extends ConsumerWidget {
  const ComplaintListScreen({super.key});

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.open:
        return AppColors.warning;
      case ComplaintStatus.inProgress:
        return AppColors.info;
      case ComplaintStatus.resolved:
        return AppColors.success;
      case ComplaintStatus.closed:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaints = ref.watch(complaintProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complaints & Helpdesk',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ComplaintFormScreen()),
              );
            },
          ),
        ],
      ),
      body: complaints.isEmpty
          ? EmptyStateWidget(
              title: 'No Active Tickets',
              message: 'Raise a ticket if you experience any maintenance issues.',
              icon: Icons.build_outlined,
              buttonLabel: 'Raise Complaint Ticket',
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ComplaintFormScreen()),
                );
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                final ticket = complaints[index];
                final statusColor = _getStatusColor(ticket.status);

                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ComplaintDetailScreen(complaint: ticket),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              PriorityChip(priority: ticket.priority),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  ticket.category.name.toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              ticket.status.name.toUpperCase(),
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ticket.title,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ticket.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Flat ${ticket.flatNumber} • ${ticket.createdBy}',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy').format(ticket.createdAt),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ComplaintFormScreen()),
          );
        },
        icon: const Icon(Icons.build),
        label: const Text('Raise Ticket'),
      ),
    );
  }
}
