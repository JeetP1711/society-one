enum ResidentType { owner, tenant }
enum StaffRole { guard, plumber, sweeper, gardener, electrician }

class ResidentMember {
  final String id;
  final String name;
  final String flatNumber;
  final String block;
  final String phone;
  final String email;
  final ResidentType type;

  const ResidentMember({
    required this.id,
    required this.name,
    required this.flatNumber,
    required this.block,
    required this.phone,
    required this.email,
    required this.type,
  });
}

class StaffWorker {
  final String id;
  final String name;
  final StaffRole role;
  final String phone;
  final String shift;
  final String timing;
  final double rating;

  const StaffWorker({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.shift,
    required this.timing,
    required this.rating,
  });
}
