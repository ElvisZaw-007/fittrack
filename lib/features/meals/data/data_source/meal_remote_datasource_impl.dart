import 'package:fittrack/features/meals/data/data_source/meal_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/meal_model.dart';

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final SupabaseClient _supabase;

  const MealRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<MealModel>> getMeals() async {
    try {
      final userId = _supabase.auth.currentUser!.id;

      final response = await _supabase
          .from('meal_logs')
          .select()
          .eq('user_id', userId)
          .order('logged_at', ascending: false);

      return response
          .map<MealModel>((json) => MealModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addMeal(MealModel meal) async {
    final userId = _supabase.auth.currentUser!.id;
    try {
      await _supabase
          .from('meal_logs')
          .insert(meal.toInsertJson(userId: userId));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getTodayCalories() async {
    final userId = _supabase.auth.currentUser!.id;

    final today = DateTime.now().toIso8601String().split('T').first;

    final response = await _supabase
        .from('meal_logs')
        .select('calories')
        .eq('user_id', userId)
        .eq('logged_at', today);
    int total = 0;

    for (final item in response) {
      total += (item['calories'] as num).toInt();
    }

    return total;
  }

  @override
  Future<void> updateMeal(MealModel meal) async {
    final userId = _supabase.auth.currentUser!.id;
    try {
      await _supabase
          .from('meal_logs')
          .update(meal.toUpdateJson())
          .eq('id', meal.id)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteMeal(String mId) async {
    final userId = _supabase.auth.currentUser!.id;
    try {
      await _supabase
          .from('meal_logs')
          .delete()
          .eq('id', mId)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }
}
