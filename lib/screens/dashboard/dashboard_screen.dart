import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import '../../models/visitor_model.dart';
import '../../models/maintenance_model.dart';
import '../../models/complaint_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/visitor_provider.dart';
import '../../providers/maintenance_provider.dart';
import '../../providers/announcement_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/quick_action_card.dart';
import '../visitors/visitor_form_screen.dart';
import '../visitors/gate_pass_screen.dart';
import '../amenities/amenity_booking_screen.dart';
import '../complaints/complaint_form_screen.dart';
import '../maintenance/maintenance_screen.dart';
import '../announcements/announcements_screen.dart';
import '../visitors/visitor_list_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).currentUser;
    final visitors = ref.watch(visitorProvider);
    final maintenance = ref.watch(maintenanceProvider);
    final announcements = ref.watch(announcementProvider);
    final complaints = ref.watch(complaintProvider);

    final pendingVisitorsCount =
        visitors.where((v) => v.status == VisitorStatus.pending).length;
    final pendingMaintenanceCount =
        maintenance.where((m) => m.status != PaymentStatus.paid).length;
    final openComplaintsCount =
        complaints.where((c) => c.status != ComplaintStatus.resolved).length;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.societyName ?? 'SocietyOne',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Powai, Mumbai',
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.lightTextSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Header Card
              GlassCard(
                customColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.primaryDark.withOpacity(0.3)
                    : AppColors.primary.withOpacity(0.08),
                borderColor: AppColors.primary.withOpacity(0.3),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        user != null && user.fullName.isNotEmpty ? user.fullName[0] : 'S',
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          Text(
                            user?.fullName ?? 'Resident',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              if (user?.flatNumber != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Flat ${user!.flatNumber}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user?.role.displayName ?? '',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Overview Metrics Section
              Text(
                'Overview Metrics',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  MetricCard(
                    title: 'Visitors',
                    value: '$pendingVisitorsCount',
                    subtitle: 'Pending Approvals',
                    icon: Icons.qr_code_scanner_rounded,
                    iconColor: AppColors.warning,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VisitorListScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  MetricCard(
                    title: 'Dues',
                    value: '$pendingMaintenanceCount',
                    subtitle: 'Unpaid / Overdue',
                    icon: Icons.account_balance_wallet_rounded,
                    iconColor: AppColors.danger,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MaintenanceScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  MetricCard(
                    title: 'Notices',
                    value: '${announcements.length}',
                    subtitle: 'Active Announcements',
                    icon: Icons.campaign_rounded,
                    iconColor: AppColors.info,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  MetricCard(
                    title: 'Complaints',
                    value: '$openComplaintsCount',
                    subtitle: 'Active Tickets',
                    icon: Icons.report_problem_rounded,
                    iconColor: AppColors.secondary,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick Actions Grid
              Text(
                'Quick Actions',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.82,
                children: [
                  QuickActionCard(
                    label: 'Gate Pass',
                    icon: Icons.qr_code_2_rounded,
                    color: AppColors.primary,
                    onTap: () {
                      if (visitors.isNotEmpty &&
                          visitors.any((v) => v.status == VisitorStatus.approved)) {
                        final appv =
                            visitors.firstWhere((v) => v.status == VisitorStatus.approved);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GatePassScreen(visitor: appv),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const VisitorFormScreen()),
                        );
                      }
                    },
                  ),
                  QuickActionCard(
                    label: 'Book Amenity',
                    icon: Icons.pool_rounded,
                    color: AppColors.secondary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AmenityBookingScreen(),
                        ),
                      );
                    },
                  ),
                  QuickActionCard(
                    label: 'Raise Ticket',
                    icon: Icons.build_rounded,
                    color: AppColors.warning,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ComplaintFormScreen(),
                        ),
                      );
                    },
                  ),
                  QuickActionCard(
                    label: 'Pay Dues',
                    icon: Icons.payment_rounded,
                    color: AppColors.danger,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MaintenanceScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Notice Highlight
              if (announcements.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Latest Announcement',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.urgent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              announcements.first.category.name.toUpperCase(),
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.urgent,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            announcements.first.authorName,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        announcements.first.title,
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        announcements.first.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
