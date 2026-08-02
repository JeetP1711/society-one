import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/society_model.dart';
import '../../providers/society_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/status_badge.dart';

class AdminSocietiesScreen extends ConsumerStatefulWidget {
  const AdminSocietiesScreen({super.key});

  @override
  ConsumerState<AdminSocietiesScreen> createState() => _AdminSocietiesScreenState();
}

class _AdminSocietiesScreenState extends ConsumerState<AdminSocietiesScreen> {
  void _showRegisterSocietyDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final regCtrl = TextEditingController();
    final addrCtrl = TextEditingController();
    final flatsCtrl = TextEditingController(text: '100');
    final secCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Register New Housing Society',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Society Full Name *'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: regCtrl,
                decoration: const InputDecoration(
                  labelText: 'Registration Certificate No *',
                  hintText: 'e.g. REG-MUM-2026-XXXX',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addrCtrl,
                decoration: const InputDecoration(labelText: 'Full Address *'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: flatsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Total Flats'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: secCtrl,
                      decoration: const InputDecoration(labelText: 'Secretary Name'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Secretary Phone'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.trim().isNotEmpty && regCtrl.text.trim().isNotEmpty) {
                    ref.read(societyProvider.notifier).registerSociety(
                          name: nameCtrl.text.trim(),
                          registrationNumber: regCtrl.text.trim(),
                          address: addrCtrl.text.trim(),
                          totalFlats: int.tryParse(flatsCtrl.text) ?? 50,
                          secretaryName: secCtrl.text.trim(),
                          contactPhone: phoneCtrl.text.trim(),
                        );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Society Registered! Pending verification.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
                child: const Text('SUBMIT REGISTRATION'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final societies = ref.watch(societyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Panel — Societies',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business),
            onPressed: () => _showRegisterSocietyDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: societies.length,
        itemBuilder: (context, index) {
          final society = societies[index];

          return GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        society.name,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (society.status == SocietyStatus.approved)
                      StatusBadge.approved()
                    else if (society.status == SocietyStatus.pending)
                      StatusBadge.pending()
                    else
                      StatusBadge.denied(),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Reg No: ${society.registrationNumber}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  society.address,
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
                      'Total Flats: ${society.totalFlats}',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                    Text(
                      'Sec: ${society.secretaryName}',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  'Registered: ${DateFormat('dd MMM yyyy').format(society.registrationDate)}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),

                if (society.status == SocietyStatus.pending) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.danger,
                          ),
                          onPressed: () {
                            ref
                                .read(societyProvider.notifier)
                                .rejectSociety(society.id);
                          },
                          child: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(societyProvider.notifier)
                                .approveSociety(society.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Society Approved on Platform!'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                          child: const Text('Approve Society'),
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
        onPressed: () => _showRegisterSocietyDialog(context),
        icon: const Icon(Icons.domain_add),
        label: const Text('Register Society'),
      ),
    );
  }
}
