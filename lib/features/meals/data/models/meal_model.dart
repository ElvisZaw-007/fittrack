import 'package:fittrack/features/meals/domain/entities/meal_entity.dart';

class MealModel {
  final String id;
  final String mealName;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final DateTime loggedAt;
  final String? notes;

  const MealModel({
    required this.id,
    required this.mealName,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.loggedAt,
    this.notes,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'],
      mealName: json['meal_name'],
      calories: json['calories'],
      proteinG: (json['protein_g'] as num).toDouble(),
      carbsG: (json['carbs_g'] as num).toDouble(),
      fatG: (json['fat_g'] as num).toDouble(),
      loggedAt: DateTime.parse(json['logged_at'] as String),
      notes: json['notes'] as String?,
    );
  }

  MealEntity toEntity() {
    return MealEntity(
      id: id,
      mealName: mealName,
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      loggedAt: loggedAt,
      notes: notes,
    );
  }

  Map<String, dynamic> toInsertJson({required String userId}) {
    return {
      'user_id': userId,
      'meal_name': mealName,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fat_g': fatG,
      'logged_at': loggedAt.toIso8601String().split('T').first,
      'notes': notes,
    };
  }

  factory MealModel.fromEntity(MealEntity entity) {
    return MealModel(
      id: entity.id ?? '',
      mealName: entity.mealName,
      calories: entity.calories,
      proteinG: entity.proteinG,
      carbsG: entity.carbsG,
      fatG: entity.fatG,
      loggedAt: entity.loggedAt,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meal_name': mealName,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fat_g': fatG,
      'logged_at': loggedAt.toIso8601String(),
      'notes': notes,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'meal_name': mealName,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fat_g': fatG,
      'logged_at': loggedAt.toIso8601String().split('T').first,
      'notes': notes,
    };
  }
}
