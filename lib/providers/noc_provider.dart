import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/noc_model.dart';
import 'mock_data.dart';

class NocNotifier extends StateNotifier<List<NocRequest>> {
  NocNotifier() : super(MockData.initialNocRequests);

  void submitNocRequest({
    required String flatNumber,
    required String applicantName,
    required String tenantName,
    required String purpose,
  }) {
    final request = NocRequest(
      id: const Uuid().v4(),
      flatNumber: flatNumber,
      applicantName: applicantName,
      tenantName: tenantName,
      purpose: purpose,
      status: NocStatus.pending,
      requestDate: DateTime.now(),
    );
    state = [request, ...state];
  }

  void approveNoc(String id, String secretaryName, String remarks) {
    state = state.map((n) {
      if (n.id == id) {
        return n.copyWith(
          status: NocStatus.approved,
          approvedBy: secretaryName,
          secretaryRemarks: remarks.isNotEmpty ? remarks : 'Approved by Secretary',
        );
      }
      return n;
    }).toList();
  }

  void rejectNoc(String id, String remarks) {
    state = state.map((n) {
      if (n.id == id) {
        return n.copyWith(
          status: NocStatus.rejected,
          secretaryRemarks: remarks,
        );
      }
      return n;
    }).toList();
  }
}

final nocProvider = StateNotifierProvider<NocNotifier, List<NocRequest>>((ref) {
  return NocNotifier();
});
