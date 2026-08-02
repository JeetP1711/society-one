enum NocStatus { pending, approved, rejected }

class NocRequest {
  final String id;
  final String flatNumber;
  final String applicantName;
  final String tenantName;
  final String purpose;
  final NocStatus status;
  final DateTime requestDate;
  final String? secretaryRemarks;
  final String? approvedBy;

  const NocRequest({
    required this.id,
    required this.flatNumber,
    required this.applicantName,
    required this.tenantName,
    required this.purpose,
    required this.status,
    required this.requestDate,
    this.secretaryRemarks,
    this.approvedBy,
  });

  NocRequest copyWith({
    String? id,
    String? flatNumber,
    String? applicantName,
    String? tenantName,
    String? purpose,
    NocStatus? status,
    DateTime? requestDate,
    String? secretaryRemarks,
    String? approvedBy,
  }) {
    return NocRequest(
      id: id ?? this.id,
      flatNumber: flatNumber ?? this.flatNumber,
      applicantName: applicantName ?? this.applicantName,
      tenantName: tenantName ?? this.tenantName,
      purpose: purpose ?? this.purpose,
      status: status ?? this.status,
      requestDate: requestDate ?? this.requestDate,
      secretaryRemarks: secretaryRemarks ?? this.secretaryRemarks,
      approvedBy: approvedBy ?? this.approvedBy,
    );
  }
}
