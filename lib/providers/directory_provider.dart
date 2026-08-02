import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/directory_model.dart';
import 'mock_data.dart';

final residentMembersProvider = Provider<List<ResidentMember>>((ref) {
  return MockData.initialMembers;
});

final staffWorkersProvider = Provider<List<StaffWorker>>((ref) {
  return MockData.initialStaff;
});
