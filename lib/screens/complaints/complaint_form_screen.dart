import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/announcement_model.dart';
import '../../models/complaint_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../theme/app_colors.dart';

class ComplaintFormScreen extends ConsumerStatefulWidget {
  const ComplaintFormScreen({super.key});

  @override
  ConsumerState<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends ConsumerState<ComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  ComplaintCategory _category = ComplaintCategory.plumbing;
  PriorityLevel _priority = PriorityLevel.medium;

  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(authProvider).currentUser;

      ref.read(complaintProvider.notifier).createComplaint(
            title: _titleController.text.trim(),
            description: _descController.text.trim(),
            category: _category,
            priority: _priority,
            createdBy: user?.fullName ?? 'Resident',
            flatNumber: user?.flatNumber ?? 'A-101',
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Helpdesk Ticket Raised Successfully!'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Raise Maintenance Ticket',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Submit Issue Details',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Our maintenance staff will be assigned automatically.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Issue Summary / Title *',
                  hintText: 'e.g. Water leak in kitchen tap',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Detailed Description *',
                  hintText: 'Explain the issue location and severity...',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Please describe the issue' : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<ComplaintCategory>(
                      value: _category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: ComplaintCategory.values
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.name.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _category = val!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<PriorityLevel>(
                      value: _priority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: PriorityLevel.values
                          .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text(p.name.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _priority = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _submitTicket,
                icon: const Icon(Icons.send_rounded),
                label: Text(
                  'SUBMIT TICKET',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
