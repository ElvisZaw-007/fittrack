import 'dart:convert';

import 'package:fittrack/core/hive/hive_service.dart';
import 'package:hive/hive.dart';

import '../models/workout_model.dart';
import 'workout_local_datasource.dart';

class WorkoutLocalDataSourceImpl implements WorkoutLocalDataSource {
  static const _key = 'cached_workouts';

  Box<String> get _box => HiveService.workoutsBox;

  @override
  Future<List<WorkoutModel>> getCachedWorkouts() async {
    final raw = _box.get(_key);
    if (raw == null) return [];

    final list = jsonDecode(raw) as List<dynamic>;

    return list
        .map((item) => WorkoutModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheWorkouts(List<WorkoutModel> workouts) async {
    final json = jsonEncode(
      workouts.map((workout) => workout.toJson()).toList(),
    );

    await _box.put(_key, json);
  }

  @override
  Future<void> clearCache() async {
    await _box.delete(_key);
  }
}
