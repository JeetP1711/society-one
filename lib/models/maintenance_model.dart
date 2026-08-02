enum PaymentStatus { paid, pending, overdue }

class MaintenanceDue {
  final String id;
  final String flatNumber;
  final String ownerName;
  final String monthYear; // e.g. "August 2026"
  final double amount;
  final PaymentStatus status;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String? transactionRef;

  const MaintenanceDue({
    required this.id,
    required this.flatNumber,
    required this.ownerName,
    required this.monthYear,
    required this.amount,
    required this.status,
    required this.dueDate,
    this.paidDate,
    this.transactionRef,
  });

  MaintenanceDue copyWith({
    String? id,
    String? flatNumber,
    String? ownerName,
    String? monthYear,
    double? amount,
    PaymentStatus? status,
    DateTime? dueDate,
    DateTime? paidDate,
    String? transactionRef,
  }) {
    return MaintenanceDue(
      id: id ?? this.id,
      flatNumber: flatNumber ?? this.flatNumber,
      ownerName: ownerName ?? this.ownerName,
      monthYear: monthYear ?? this.monthYear,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      transactionRef: transactionRef ?? this.transactionRef,
    );
  }
}

class FundContribution {
  final String id;
  final String flatNumber;
  final String contributorName;
  final double amount;
  final DateTime date;

  const FundContribution({
    required this.id,
    required this.flatNumber,
    required this.contributorName,
    required this.amount,
    required this.date,
  });
}

class FestivalFund {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  final double collectedAmount;
  final DateTime endDate;
  final List<FundContribution> contributions;

  const FestivalFund({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.collectedAmount,
    required this.endDate,
    required this.contributions,
  });

  FestivalFund copyWith({
    String? id,
    String? title,
    String? description,
    double? targetAmount,
    double? collectedAmount,
    DateTime? endDate,
    List<FundContribution>? contributions,
  }) {
    return FestivalFund(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      collectedAmount: collectedAmount ?? this.collectedAmount,
      endDate: endDate ?? this.endDate,
      contributions: contributions ?? this.contributions,
    );
  }
}
