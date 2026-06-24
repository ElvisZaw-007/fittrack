import 'package:fittrack/features/weight_logs/domain/entities/weight_log.dart';

class WeightLogModel {
  final String id;
  final String userId;
  final double weightKg;
  final String loggedAt;
  final String? notes;
  final DateTime createdAt;

  const WeightLogModel({
    required this.id,
    required this.userId,
    required this.weightKg,
    required this.loggedAt,
    this.notes,
    required this.createdAt,
  });

  factory WeightLogModel.fromJson(Map<String, dynamic> json) => WeightLogModel(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    weightKg: (json['weightKg'] as num).toDouble(),
    loggedAt: json['loggedAt'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  WeightLog toEntity() => WeightLog(
    id: id,
    weightKg: weightKg,
    loggedAt: DateTime.parse(loggedAt),
    notes: notes,
  );

  //Insert payload - id and created_at are database-generated.
  //user_id comes from the authenticated session, not the entity.
  Map<String, dynamic> weightLogToInsertJson(
    WeightLog log, {
    required String userId,
  }) => {
    'user_id': userId,
    'weight_kg': log.weightKg,
    'logged_at': log.loggedAt.toIso8601String().substring(0, 10),
    if (log.notes != null) 'notes': log.notes,
  };

  ///Update payload - only mutable fields.
  ///user_id, id, created_at are never sent in updates.
  Map<String, dynamic> weightLogToUpdateJson(WeightLog log) => {
    'weight_kg': log.weightKg,
    'logged_at': log.loggedAt.toIso8601String().substring(0, 10),
    if (log.notes != null) 'notes': log.notes,
  };

  static Map<String, dynamic> toInsertJson(
    WeightLog log, {
    required String userId,
  }) {
    return {
      'user_id': userId,
      'weight_kg': log.weightKg,
      'logged_at': log.loggedAt.toIso8601String(),
      'notes': log.notes,
    };
  }

  static Map<String, dynamic> toUpdateJson(WeightLog log) {
    return {
      'weight_kg': log.weightKg,
      'logged_at': log.loggedAt.toIso8601String(),
      'notes': log.notes,
    };
  }
}
