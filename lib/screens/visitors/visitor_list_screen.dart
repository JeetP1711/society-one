import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';
import '../../models/visitor_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/visitor_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state.dart';
import 'gate_pass_screen.dart';
import 'visitor_form_screen.dart';

class VisitorListScreen extends ConsumerWidget {
  const VisitorListScreen({super.key});

  void _showDenyDialog(BuildContext context, WidgetRef ref, VisitorEntry visitor) {
    final reasonController = TextEditingController();
    final user = ref.read(authProvider).currentUser;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Deny Visitor Entry',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Denying entry for ${visitor.visitorName} to Flat ${visitor.flatNumber}.'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for Denial',
                hintText: 'e.g. Unannounced entry / Restricted hours',
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              ref.read(visitorProvider.notifier).denyVisitor(
                    visitor.id,
                    user?.fullName ?? 'Secretary',
                    reasonController.text.trim().isEmpty
                        ? 'Entry Denied by Secretary'
                        : reasonController.text.trim(),
                  );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Visitor entry denied.')),
              );
            },
            child: const Text('Deny Entry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitors = ref.watch(visitorProvider);
    final currentUser = ref.watch(authProvider).currentUser;
    final isSecretaryOrAdmin = currentUser?.role == UserRole.secretary ||
        currentUser?.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSecretaryOrAdmin ? 'Visitor Approval Feed' : 'My Visitor Gate Passes',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VisitorFormScreen()),
              );
            },
          ),
        ],
      ),
      body: visitors.isEmpty
          ? EmptyStateWidget(
              title: 'No Visitor Entries',
              message: 'Pre-approve guests or service personnel to issue QR gate passes.',
              icon: Icons.qr_code_2_rounded,
              buttonLabel: 'Add Visitor Pass',
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VisitorFormScreen()),
                );
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: visitors.length,
              itemBuilder: (context, index) {
                final visitor = visitors[index];

                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  onTap: visitor.status == VisitorStatus.approved
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GatePassScreen(visitor: visitor),
                            ),
                          );
                        }
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person_pin_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    visitor.visitorName,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Flat ${visitor.flatNumber} • ${visitor.requestedBy}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Status Badge
                          if (visitor.status == VisitorStatus.approved)
                            StatusBadge.approved()
                          else if (visitor.status == VisitorStatus.pending)
                            StatusBadge.pending()
                          else
                            StatusBadge.denied(),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          Icon(Icons.assignment_outlined,
                              size: 14,
                              color: Theme.of(context).textTheme.bodyMedium?.color),
                          const SizedBox(width: 6),
                          Text(
                            'Purpose: ${visitor.purpose}',
                            style: GoogleFonts.inter(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 14,
                              color: Theme.of(context).textTheme.bodyMedium?.color),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('dd MMM, hh:mm a')
                                .format(visitor.expectedDateTime),
                            style: GoogleFonts.inter(fontSize: 13),
                          ),
                          const Spacer(),
                          Text(
                            'Pass Code: ${visitor.passCode}',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      if (visitor.status == VisitorStatus.denied &&
                          visitor.denyReason != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Denial Reason: ${visitor.denyReason}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.danger,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],

                      // Approval Actions for Secretary
                      if (isSecretaryOrAdmin &&
                          visitor.status == VisitorStatus.pending) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.danger,
                                  side: const BorderSide(color: AppColors.danger),
                                ),
                                onPressed: () =>
                                    _showDenyDialog(context, ref, visitor),
                                icon: const Icon(Icons.close, size: 16),
                                label: const Text('Deny'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                ),
                                onPressed: () {
                                  ref
                                      .read(visitorProvider.notifier)
                                      .approveVisitor(
                                        visitor.id,
                                        currentUser?.fullName ?? 'Secretary',
                                      );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Visitor Approved! Pass active.'),
                                      backgroundColor: AppColors.success,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.check, size: 16),
                                label: const Text('Approve'),
                              ),
                            ),
                          ],
                        ),
                      ],

                      if (visitor.status == VisitorStatus.approved) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Tap to show QR Pass ',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.primary,
                              ),
                            ),
                            const Icon(Icons.qr_code,
                                size: 16, color: AppColors.primary),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
