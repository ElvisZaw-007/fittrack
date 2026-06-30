import 'package:equatable/equatable.dart';

class WeightLog extends Equatable {
  final String? id;
  final double weightKg;
  final DateTime loggedAt;
  final String? notes;

  const WeightLog({
    this.id,
    required this.weightKg,
    required this.loggedAt,
    this.notes,
  });

  WeightLog copyWith({
    String? id,
    double? weightKg,
    DateTime? loggedAt,
    String? notes,
  }) {
    return WeightLog(
      id: id ?? this.id,
      weightKg: weightKg ?? this.weightKg,
      loggedAt: loggedAt ?? this.loggedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    weightKg,
    loggedAt,
    notes,
  ];
}
