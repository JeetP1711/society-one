import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../models/maintenance_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/maintenance_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/status_badge.dart';

class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  ConsumerState<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends ConsumerState<MaintenanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _showPaymentBottomSheet(BuildContext context, MaintenanceDue due) {
    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pay Maintenance Dues',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Period: ${due.monthYear}',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                      ),
                      Text('Flat ${due.flatNumber} (${due.ownerName})'),
                    ],
                  ),
                  Text(
                    currencyFormat.format(due.amount),
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'SELECT PAYMENT METHOD',
              style: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.primary),
              ),
              leading: const Icon(Icons.qr_code_scanner, color: AppColors.primary),
              title: const Text('UPI Payment (Google Pay / PhonePe / Paytm)'),
              subtitle: const Text('Instant confirmation via UPI Intent'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ref.read(maintenanceProvider.notifier).payMaintenance(due.id, 'UPI');
                Navigator.pop(ctx);
                _showSuccessSnackBar(context);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Theme.of(context).dividerColor),
              ),
              leading: const Icon(Icons.account_balance, color: AppColors.secondary),
              title: const Text('Net Banking / Debit Card'),
              subtitle: const Text('HDFC, ICICI, SBI, Axis Bank'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ref.read(maintenanceProvider.notifier).payMaintenance(due.id, 'NETBANK');
                Navigator.pop(ctx);
                _showSuccessSnackBar(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showContributeFundDialog(BuildContext context, FestivalFund fund) {
    final amountController = TextEditingController(text: '2500');
    final user = ref.read(authProvider).currentUser;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Contribute to ${fund.title}',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Contribution Amount (₹)',
                prefixIcon: Icon(Icons.currency_rupee),
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
              final amount = double.tryParse(amountController.text) ?? 0.0;
              if (amount > 0) {
                ref.read(festivalFundProvider.notifier).contributeToFund(
                      fundId: fund.id,
                      flatNumber: user?.flatNumber ?? 'A-101',
                      contributorName: user?.fullName ?? 'Resident',
                      amount: amount,
                    );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you! Contribution received.'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('CONTRIBUTE NOW'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment Successful! Receipt generated.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final duesList = ref.watch(maintenanceProvider);
    final festivalFunds = ref.watch(festivalFundProvider);
    final currentUser = ref.watch(authProvider).currentUser;
    final isMember = currentUser?.role == UserRole.member;

    final displayedDues = isMember
        ? duesList.where((d) => d.flatNumber == currentUser?.flatNumber).toList()
        : duesList;

    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Maintenance & Funds',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Monthly Maintenance'),
            Tab(text: 'Festival Funds'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Monthly Dues Tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: displayedDues.length,
            itemBuilder: (context, index) {
              final due = displayedDues[index];

              return GlassCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              due.monthYear,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Flat ${due.flatNumber} • ${due.ownerName}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),

                        if (due.status == PaymentStatus.paid)
                          StatusBadge.paid()
                        else if (due.status == PaymentStatus.pending)
                          StatusBadge.pending()
                        else
                          StatusBadge.overdue(),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Due Date: ${DateFormat('dd MMM yyyy').format(due.dueDate)}',
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                            Text(
                              currencyFormat.format(due.amount),
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),

                        if (due.status != PaymentStatus.paid)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            onPressed: () => _showPaymentBottomSheet(context, due),
                            child: const Text('PAY NOW'),
                          )
                        else
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Receipt Ref: ${due.transactionRef ?? 'N/A'}'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.receipt_long, size: 16),
                            label: const Text('Receipt'),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // Festival Funds Tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: festivalFunds.length,
            itemBuilder: (context, index) {
              final fund = festivalFunds[index];
              final percent = (fund.collectedAmount / fund.targetAmount).clamp(0.0, 1.0);

              return GlassCard(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.celebration, color: AppColors.warning),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            fund.title,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fund.description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Target Linear Progress Bar Widget
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      lineHeight: 12.0,
                      percent: percent,
                      backgroundColor: Theme.of(context).dividerColor,
                      progressColor: AppColors.primary,
                      barRadius: const Radius.circular(6),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Collected: ${currencyFormat.format(fund.collectedAmount)}',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Target: ${currencyFormat.format(fund.targetAmount)}',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showContributeFundDialog(context, fund),
                        icon: const Icon(Icons.favorite, size: 18),
                        label: const Text('CONTRIBUTE TO FUND'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
