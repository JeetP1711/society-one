import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/amenity_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/amenity_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/status_badge.dart';

class AmenityBookingScreen extends ConsumerStatefulWidget {
  const AmenityBookingScreen({super.key});

  @override
  ConsumerState<AmenityBookingScreen> createState() => _AmenityBookingScreenState();
}

class _AmenityBookingScreenState extends ConsumerState<AmenityBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _showBookingDialog(BuildContext context, Amenity amenity) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    String startTime = '09:00 AM';
    String endTime = '11:00 AM';

    final timeSlots = [
      '06:00 AM - 08:00 AM',
      '09:00 AM - 11:00 AM',
      '02:00 PM - 04:00 PM',
      '05:00 PM - 07:00 PM',
      '07:00 PM - 09:00 PM',
    ];
    String selectedSlot = timeSlots[1];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setBottomSheetState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Book ${amenity.name}',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                amenity.rules,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 20),

              // Date Picker Button
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) {
                    setBottomSheetState(() => selectedDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('EEEE, dd MMM yyyy').format(selectedDate),
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text(
                'SELECT TIME SLOT',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: timeSlots.map((slot) {
                  final isSelected = selectedSlot == slot;
                  return ChoiceChip(
                    label: Text(slot),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setBottomSheetState(() => selectedSlot = slot);
                      }
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final user = ref.read(authProvider).currentUser;
                  final parts = selectedSlot.split(' - ');
                  startTime = parts[0];
                  endTime = parts[1];

                  ref.read(amenityBookingProvider.notifier).createBooking(
                        amenityId: amenity.id,
                        amenityName: amenity.name,
                        userId: user?.id ?? 'u-3',
                        userName: user?.fullName ?? 'Resident',
                        flatNumber: user?.flatNumber ?? 'A-101',
                        bookingDate: selectedDate,
                        startTime: startTime,
                        endTime: endTime,
                      );

                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Amenity Booking Confirmed!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: const Text('CONFIRM BOOKING'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'pool':
        return Icons.pool;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'sports_tennis':
        return Icons.sports_tennis;
      case 'home_work':
      default:
        return Icons.home_work;
    }
  }

  @override
  Widget build(BuildContext context) {
    final amenities = ref.watch(amenityListProvider);
    final bookings = ref.watch(amenityBookingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Amenities & Facilities',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Book Facilities'),
            Tab(text: 'My Bookings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Facility Cards List
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: amenities.length,
            itemBuilder: (context, index) {
              final amenity = amenities[index];
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            _getIconData(amenity.iconName),
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                amenity.name,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Capacity: Up to ${amenity.maxCapacity} people',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      amenity.description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showBookingDialog(context, amenity),
                        icon: const Icon(Icons.event_available, size: 18),
                        label: const Text('BOOK SLOT NOW'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Bookings List Tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              return GlassCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          booking.amenityName,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (booking.status == BookingStatus.confirmed)
                          StatusBadge.approved(label: 'Confirmed')
                        else
                          StatusBadge.denied(label: 'Cancelled'),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat('dd MMM yyyy').format(booking.bookingDate),
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '${booking.startTime} - ${booking.endTime}',
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                      ],
                    ),
                    if (booking.status == BookingStatus.confirmed) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                          onPressed: () {
                            ref
                                .read(amenityBookingProvider.notifier)
                                .cancelBooking(booking.id);
                          },
                          icon: const Icon(Icons.cancel_outlined, size: 16),
                          label: const Text('Cancel Booking'),
                        ),
                      ),
                    ],
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
