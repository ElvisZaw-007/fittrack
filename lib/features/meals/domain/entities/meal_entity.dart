class MealEntity {
  final String id;
  final String userId;
  final String mealName;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final DateTime loggedAt;
  final String? notes;

  const MealEntity({
    required this.id,
    required this.userId,
    required this.mealName,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.loggedAt,
    this.notes,
  });
}
