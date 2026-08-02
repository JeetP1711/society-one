enum SocietyStatus { pending, approved, rejected }

class Society {
  final String id;
  final String name;
  final String registrationNumber;
  final String address;
  final int totalFlats;
  final String secretaryName;
  final String contactPhone;
  final SocietyStatus status;
  final DateTime registrationDate;

  const Society({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.address,
    required this.totalFlats,
    required this.secretaryName,
    required this.contactPhone,
    this.status = SocietyStatus.approved,
    required this.registrationDate,
  });

  Society copyWith({
    String? id,
    String? name,
    String? registrationNumber,
    String? address,
    int? totalFlats,
    String? secretaryName,
    String? contactPhone,
    SocietyStatus? status,
    DateTime? registrationDate,
  }) {
    return Society(
      id: id ?? this.id,
      name: name ?? this.name,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      address: address ?? this.address,
      totalFlats: totalFlats ?? this.totalFlats,
      secretaryName: secretaryName ?? this.secretaryName,
      contactPhone: contactPhone ?? this.contactPhone,
      status: status ?? this.status,
      registrationDate: registrationDate ?? this.registrationDate,
    );
  }
}
