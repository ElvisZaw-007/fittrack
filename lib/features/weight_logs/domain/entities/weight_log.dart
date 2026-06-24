class WeightLog {
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
}
