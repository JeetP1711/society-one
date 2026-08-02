import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/amenity_model.dart';
import 'mock_data.dart';

final amenityListProvider = Provider<List<Amenity>>((ref) {
  return MockData.initialAmenities;
});

class AmenityBookingNotifier extends StateNotifier<List<AmenityBooking>> {
  AmenityBookingNotifier() : super(MockData.initialAmenityBookings);

  bool createBooking({
    required String amenityId,
    required String amenityName,
    required String userId,
    required String userName,
    required String flatNumber,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
  }) {
    final booking = AmenityBooking(
      id: const Uuid().v4(),
      amenityId: amenityId,
      amenityName: amenityName,
      userId: userId,
      userName: userName,
      flatNumber: flatNumber,
      bookingDate: bookingDate,
      startTime: startTime,
      endTime: endTime,
      status: BookingStatus.confirmed,
    );

    state = [booking, ...state];
    return true;
  }

  void cancelBooking(String bookingId) {
    state = state.map((b) {
      if (b.id == bookingId) {
        return b.copyWith(status: BookingStatus.cancelled);
      }
      return b;
    }).toList();
  }
}

final amenityBookingProvider =
    StateNotifierProvider<AmenityBookingNotifier, List<AmenityBooking>>((ref) {
  return AmenityBookingNotifier();
});
