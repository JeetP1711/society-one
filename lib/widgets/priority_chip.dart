import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/announcement_model.dart';
import '../theme/app_colors.dart';

class PriorityChip extends StatelessWidget {
  final PriorityLevel priority;

  const PriorityChip({super.key, required this.priority});

  Color _getColor() {
    switch (priority) {
      case PriorityLevel.urgent:
        return AppColors.urgent;
      case PriorityLevel.high:
        return AppColors.high;
      case PriorityLevel.medium:
        return AppColors.medium;
      case PriorityLevel.low:
        return AppColors.low;
    }
  }

  String _getLabel() {
    switch (priority) {
      case PriorityLevel.urgent:
        return 'URGENT';
      case PriorityLevel.high:
        return 'HIGH';
      case PriorityLevel.medium:
        return 'MEDIUM';
      case PriorityLevel.low:
        return 'LOW';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        _getLabel(),
        style: GoogleFonts.montserrat(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
