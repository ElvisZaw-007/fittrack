import 'package:fittrack/features/meals/domain/entities/meal_entity.dart';

class MealModel {
  final String id;
  final String userId;
  final String mealName;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final DateTime loggedAt;
  final String? notes;

  const MealModel({
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

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'],
      userId: json['user_id'],
      mealName: json['meal_name'],
      calories: json['calories'],
      proteinG: (json['protein_g'] as num).toDouble(),
      carbsG: (json['carbs_g'] as num).toDouble(),
      fatG: (json['fat_g'] as num).toDouble(),
      loggedAt: DateTime.parse(json['logged_at']),
      notes: json['notes'],
    );
  }

  MealEntity toEntity() {
    return MealEntity(
      id: id,
      userId: userId,
      mealName: mealName,
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      loggedAt: loggedAt,
      notes: notes,
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'meal_name': mealName,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fat_g': fatG,
      'logged_at': loggedAt.toIso8601String(),
      'notes': notes,
    };
  }

  factory MealModel.fromEntity(MealEntity entity) {
    return MealModel(
      id: entity.id,
      userId: entity.userId,
      mealName: entity.mealName,
      calories: entity.calories,
      proteinG: entity.proteinG,
      carbsG: entity.carbsG,
      fatG: entity.fatG,
      loggedAt: entity.loggedAt,
      notes: entity.notes,
    );
  }
}
