import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/visitor_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

class GatePassScreen extends StatelessWidget {
  final VisitorEntry visitor;

  const GatePassScreen({super.key, required this.visitor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Digital Gate Pass',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              // Pass Card Container
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shield, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'GREEN VALLEY CHS',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'OFFICIAL SECURITY GATE PASS',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // QR Code Display Widget
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: 'SOCIETYONE:${visitor.passCode}:${visitor.flatNumber}',
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      visitor.passCode,
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Scan at security kiosk for verification',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),

                    const Divider(height: 32),

                    // Details List
                    _buildDetailRow('Visitor Name', visitor.visitorName),
                    _buildDetailRow('Flat Target', 'Flat ${visitor.flatNumber}'),
                    _buildDetailRow('Purpose', visitor.purpose),
                    _buildDetailRow('Vehicle No', visitor.vehicleNo),
                    _buildDetailRow(
                      'Expected Time',
                      DateFormat('dd MMM yyyy, hh:mm a')
                          .format(visitor.expectedDateTime),
                    ),
                    _buildDetailRow('Approved By', visitor.approvedBy ?? 'Secretary'),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'Pass valid for single entry on scheduled date.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
