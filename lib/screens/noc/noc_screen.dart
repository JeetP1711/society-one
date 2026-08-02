import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/noc_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/noc_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/status_badge.dart';

class NocScreen extends ConsumerStatefulWidget {
  const NocScreen({super.key});

  @override
  ConsumerState<NocScreen> createState() => _NocScreenState();
}

class _NocScreenState extends ConsumerState<NocScreen> {
  void _showNewNocModal(BuildContext context) {
    final tenantController = TextEditingController();
    final purposeController = TextEditingController(
        text: 'Tenant Rental Leave & License Agreement (11 Months)');
    final user = ref.read(authProvider).currentUser;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
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
              'Apply for Tenant NOC Certificate',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Required for tenant registration and agreement verification.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tenantController,
              decoration: const InputDecoration(
                labelText: 'Tenant Full Name & Employment Info *',
                hintText: 'e.g. Vikram Joshi (Software Engineer)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: purposeController,
              decoration: const InputDecoration(
                labelText: 'Purpose / Agreement Duration *',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (tenantController.text.trim().isNotEmpty) {
                  ref.read(nocProvider.notifier).submitNocRequest(
                        flatNumber: user?.flatNumber ?? 'A-101',
                        applicantName: user?.fullName ?? 'Resident Owner',
                        tenantName: tenantController.text.trim(),
                        purpose: purposeController.text.trim(),
                      );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('NOC Request Submitted to Secretary!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: const Text('SUBMIT NOC APPLICATION'),
            ),
          ],
        ),
      ),
    );
  }

  void _showApproveDialog(BuildContext context, NocRequest req) {
    final remarkController =
        TextEditingController(text: 'Police verification and agreement verified.');
    final user = ref.read(authProvider).currentUser;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Approve NOC Request',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Approving NOC for Flat ${req.flatNumber} (${req.tenantName}).'),
            const SizedBox(height: 12),
            TextField(
              controller: remarkController,
              decoration: const InputDecoration(labelText: 'Secretary Remarks'),
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
              ref.read(nocProvider.notifier).approveNoc(
                    req.id,
                    user?.fullName ?? 'Secretary',
                    remarkController.text.trim(),
                  );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('NOC Approved & Issued!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('APPROVE & ISSUE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nocs = ref.watch(nocProvider);
    final currentUser = ref.watch(authProvider).currentUser;
    final isSecretary = currentUser?.role == UserRole.secretary ||
        currentUser?.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'No Objection Certificates (NOC)',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showNewNocModal(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: nocs.length,
        itemBuilder: (context, index) {
          final req = nocs[index];

          return GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Flat ${req.flatNumber} NOC Application',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (req.status == NocStatus.approved)
                      StatusBadge.approved()
                    else if (req.status == NocStatus.pending)
                      StatusBadge.pending()
                    else
                      StatusBadge.denied(),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Owner: ${req.applicantName}',
                  style: GoogleFonts.inter(fontSize: 13),
                ),
                Text(
                  'Proposed Tenant: ${req.tenantName}',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Purpose: ${req.purpose}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Applied: ${DateFormat('dd MMM yyyy').format(req.requestDate)}',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                    if (req.status == NocStatus.approved)
                      Text(
                        'Approved by ${req.approvedBy}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                if (req.secretaryRemarks != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Remarks: ${req.secretaryRemarks}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.secondary,
                    ),
                  ),
                ],

                if (isSecretary && req.status == NocStatus.pending) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger),
                          onPressed: () {
                            ref
                                .read(nocProvider.notifier)
                                .rejectNoc(req.id, 'Documentation incomplete');
                          },
                          child: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showApproveDialog(context, req),
                          child: const Text('Approve NOC'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewNocModal(context),
        icon: const Icon(Icons.verified_user),
        label: const Text('Apply NOC'),
      ),
    );
  }
}
