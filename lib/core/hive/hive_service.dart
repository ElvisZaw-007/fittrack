// lib/core/hive/hive_service.dart

import 'package:hive_flutter/adapters.dart';

abstract final class HiveBoxes {
  static const weightLogs = 'weight_logs';
  static const workouts = 'workout_logs';
  static const meals = 'meal_logs';
  static const goals = 'goals';
  static const profile = 'profile';
}

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    //Open all boxes at start
    //Lazy opening during a network failure is itself a rish.
    await Future.wait([
      Hive.openBox<String>(HiveBoxes.weightLogs),
      Hive.openBox<String>(HiveBoxes.workouts),
      Hive.openBox<String>(HiveBoxes.meals),
      Hive.openBox<String>(HiveBoxes.goals),
      Hive.openBox<String>(HiveBoxes.profile),
    ]);
  }

  static Box<String> get weightLogsBox =>
      Hive.box<String>(HiveBoxes.weightLogs);
  static Box<String> get workoutsBox => Hive.box<String>(HiveBoxes.workouts);
  static Box<String> get mealsBox => Hive.box<String>(HiveBoxes.meals);
  static Box<String> get goalsBox => Hive.box<String>(HiveBoxes.goals);
  static Box<String> get profileBox => Hive.box<String>(HiveBoxes.profile);
}
