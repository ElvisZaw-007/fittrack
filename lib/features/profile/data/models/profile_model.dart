// lib/features/profile/data/models/profile_model.dart

import 'package:fittrack/features/profile/domain/entities/profile.dart';

class ProfileModel {
  final String userId;
  final String name;
  final int age;
  final double heightCm;
  final String unitPref;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileModel({
    required this.userId,
    required this.name,
    required this.age,
    required this.heightCm,
    required this.unitPref,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    userId: json['user_id'] as String,
    name: json['name'] as String,
    age: json['age'] as int,
    heightCm: (json['height_cm'] as num).toDouble(),
    unitPref: json['unit_pref'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'age': age,
    'height_cm': heightCm,
    'unit_pref': unitPref,
    // Omit created_at and updated_at — the database owns these
  };

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      userId: profile.userId,
      name: profile.name,
      age: profile.age,
      heightCm: profile.heightCm,
      unitPref: profile.unitPreference.name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Profile toEntity() => Profile(
    userId: userId,
    name: name,
    age: age,
    heightCm: heightCm,
    unitPreference: UnitPreference.values.byName(unitPref),
  );
}

/// Builds the upsert payload directly from the domain entity.
/// Audit timestamps (created_at, updated_at) are intentionally
/// omitted — the database owns them via column default and trigger.
Map<String, dynamic> profileToUpsertJson(Profile profile) => {
  'user_id': profile.userId,
  'name': profile.name,
  'age': profile.age,
  'height_cm': profile.heightCm,
  'unit_pref': profile.unitPreference.name,
};
