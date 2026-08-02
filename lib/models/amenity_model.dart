enum BookingStatus { confirmed, pending, cancelled }

class Amenity {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final String rules;
  final int maxCapacity;

  const Amenity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.rules,
    required this.maxCapacity,
  });
}

class AmenityBooking {
  final String id;
  final String amenityId;
  final String amenityName;
  final String userId;
  final String userName;
  final String flatNumber;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final BookingStatus status;

  const AmenityBooking({
    required this.id,
    required this.amenityId,
    required this.amenityName,
    required this.userId,
    required this.userName,
    required this.flatNumber,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  AmenityBooking copyWith({
    String? id,
    String? amenityId,
    String? amenityName,
    String? userId,
    String? userName,
    String? flatNumber,
    DateTime? bookingDate,
    String? startTime,
    String? endTime,
    BookingStatus? status,
  }) {
    return AmenityBooking(
      id: id ?? this.id,
      amenityId: amenityId ?? this.amenityId,
      amenityName: amenityName ?? this.amenityName,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      flatNumber: flatNumber ?? this.flatNumber,
      bookingDate: bookingDate ?? this.bookingDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
    );
  }
}
