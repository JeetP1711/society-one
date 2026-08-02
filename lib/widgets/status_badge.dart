import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  factory StatusBadge.approved({String label = 'Approved'}) =>
      StatusBadge(label: label, color: AppColors.success, icon: Icons.check_circle_outline);

  factory StatusBadge.pending({String label = 'Pending'}) =>
      StatusBadge(label: label, color: AppColors.warning, icon: Icons.access_time);

  factory StatusBadge.denied({String label = 'Denied'}) =>
      StatusBadge(label: label, color: AppColors.danger, icon: Icons.cancel_outlined);

  factory StatusBadge.paid({String label = 'Paid'}) =>
      StatusBadge(label: label, color: AppColors.success, icon: Icons.verified_outlined);

  factory StatusBadge.overdue({String label = 'Overdue'}) =>
      StatusBadge(label: label, color: AppColors.danger, icon: Icons.warning_amber_rounded);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
