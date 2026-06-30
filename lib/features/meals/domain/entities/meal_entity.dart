class MealEntity {
  final String? id;
  final String mealName;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final DateTime loggedAt;
  final String? notes;

  const MealEntity({
    this.id,
    required this.mealName,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.loggedAt,
    this.notes,
  });

  factory MealEntity.fromEntity(MealEntity entity) {
    return MealEntity(
      id: entity.id,
      mealName: entity.mealName,
      calories: entity.calories,
      proteinG: entity.proteinG,
      carbsG: entity.carbsG,
      fatG: entity.fatG,
      loggedAt: entity.loggedAt,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'meal_name': mealName,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fat_g': fatG,
      'logged_at': loggedAt.toIso8601String(),
      'notes': notes,
    };
  }
}
