enum VisitorStatus { pending, approved, denied, checkedIn, checkedOut }

class VisitorEntry {
  final String id;
  final String visitorName;
  final String phone;
  final String purpose;
  final DateTime expectedDateTime;
  final String vehicleNo;
  final String flatNumber;
  final String requestedBy;
  final VisitorStatus status;
  final String passCode;
  final String? approvedBy;
  final String? denyReason;
  final DateTime createdAt;

  const VisitorEntry({
    required this.id,
    required this.visitorName,
    required this.phone,
    required this.purpose,
    required this.expectedDateTime,
    required this.vehicleNo,
    required this.flatNumber,
    required this.requestedBy,
    this.status = VisitorStatus.pending,
    required this.passCode,
    this.approvedBy,
    this.denyReason,
    required this.createdAt,
  });

  VisitorEntry copyWith({
    String? id,
    String? visitorName,
    String? phone,
    String? purpose,
    DateTime? expectedDateTime,
    String? vehicleNo,
    String? flatNumber,
    String? requestedBy,
    VisitorStatus? status,
    String? passCode,
    String? approvedBy,
    String? denyReason,
    DateTime? createdAt,
  }) {
    return VisitorEntry(
      id: id ?? this.id,
      visitorName: visitorName ?? this.visitorName,
      phone: phone ?? this.phone,
      purpose: purpose ?? this.purpose,
      expectedDateTime: expectedDateTime ?? this.expectedDateTime,
      vehicleNo: vehicleNo ?? this.vehicleNo,
      flatNumber: flatNumber ?? this.flatNumber,
      requestedBy: requestedBy ?? this.requestedBy,
      status: status ?? this.status,
      passCode: passCode ?? this.passCode,
      approvedBy: approvedBy ?? this.approvedBy,
      denyReason: denyReason ?? this.denyReason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
