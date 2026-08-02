import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/visitor_model.dart';
import 'mock_data.dart';

class VisitorNotifier extends StateNotifier<List<VisitorEntry>> {
  VisitorNotifier() : super(MockData.initialVisitors);

  void addVisitor({
    required String visitorName,
    required String phone,
    required String purpose,
    required DateTime expectedDateTime,
    required String vehicleNo,
    required String flatNumber,
    required String requestedBy,
  }) {
    final passCode = 'GV-2026-${(1000 + state.length * 37 % 8999).toInt()}';
    final entry = VisitorEntry(
      id: const Uuid().v4(),
      visitorName: visitorName,
      phone: phone,
      purpose: purpose,
      expectedDateTime: expectedDateTime,
      vehicleNo: vehicleNo.isEmpty ? 'N/A' : vehicleNo,
      flatNumber: flatNumber,
      requestedBy: requestedBy,
      status: VisitorStatus.pending,
      passCode: passCode,
      createdAt: DateTime.now(),
    );
    state = [entry, ...state];
  }

  void approveVisitor(String id, String secretaryName) {
    state = state.map((v) {
      if (v.id == id) {
        return v.copyWith(
          status: VisitorStatus.approved,
          approvedBy: secretaryName,
        );
      }
      return v;
    }).toList();
  }

  void denyVisitor(String id, String secretaryName, String reason) {
    state = state.map((v) {
      if (v.id == id) {
        return v.copyWith(
          status: VisitorStatus.denied,
          approvedBy: secretaryName,
          denyReason: reason,
        );
      }
      return v;
    }).toList();
  }
}

final visitorProvider = StateNotifierProvider<VisitorNotifier, List<VisitorEntry>>((ref) {
  return VisitorNotifier();
});
