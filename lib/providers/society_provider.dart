import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/society_model.dart';
import 'mock_data.dart';

class SocietyNotifier extends StateNotifier<List<Society>> {
  SocietyNotifier() : super(MockData.initialSocieties);

  void registerSociety({
    required String name,
    required String registrationNumber,
    required String address,
    required int totalFlats,
    required String secretaryName,
    required String contactPhone,
  }) {
    final society = Society(
      id: const Uuid().v4(),
      name: name,
      registrationNumber: registrationNumber,
      address: address,
      totalFlats: totalFlats,
      secretaryName: secretaryName,
      contactPhone: contactPhone,
      status: SocietyStatus.pending,
      registrationDate: DateTime.now(),
    );
    state = [society, ...state];
  }

  void approveSociety(String id) {
    state = state.map((s) {
      if (s.id == id) {
        return s.copyWith(status: SocietyStatus.approved);
      }
      return s;
    }).toList();
  }

  void rejectSociety(String id) {
    state = state.map((s) {
      if (s.id == id) {
        return s.copyWith(status: SocietyStatus.rejected);
      }
      return s;
    }).toList();
  }
}

final societyProvider = StateNotifierProvider<SocietyNotifier, List<Society>>((ref) {
  return SocietyNotifier();
});
