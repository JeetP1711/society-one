import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/maintenance_model.dart';
import 'mock_data.dart';

class MaintenanceNotifier extends StateNotifier<List<MaintenanceDue>> {
  MaintenanceNotifier() : super(MockData.initialMaintenance);

  void payMaintenance(String id, String paymentMethod) {
    state = state.map((m) {
      if (m.id == id) {
        return m.copyWith(
          status: PaymentStatus.paid,
          paidDate: DateTime.now(),
          transactionRef: '$paymentMethod/${DateTime.now().millisecondsSinceEpoch}/SUCCESS',
        );
      }
      return m;
    }).toList();
  }
}

final maintenanceProvider =
    StateNotifierProvider<MaintenanceNotifier, List<MaintenanceDue>>((ref) {
  return MaintenanceNotifier();
});

class FestivalFundNotifier extends StateNotifier<List<FestivalFund>> {
  FestivalFundNotifier() : super(MockData.initialFestivalFunds);

  void contributeToFund({
    required String fundId,
    required String flatNumber,
    required String contributorName,
    required double amount,
  }) {
    state = state.map((f) {
      if (f.id == fundId) {
        final newContrib = FundContribution(
          id: const Uuid().v4(),
          flatNumber: flatNumber,
          contributorName: contributorName,
          amount: amount,
          date: DateTime.now(),
        );
        return f.copyWith(
          collectedAmount: f.collectedAmount + amount,
          contributions: [newContrib, ...f.contributions],
        );
      }
      return f;
    }).toList();
  }
}

final festivalFundProvider =
    StateNotifierProvider<FestivalFundNotifier, List<FestivalFund>>((ref) {
  return FestivalFundNotifier();
});
