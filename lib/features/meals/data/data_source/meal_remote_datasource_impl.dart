import 'package:fittrack/features/meals/data/data_source/meal_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/meal_model.dart';

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final SupabaseClient _supabase;

  const MealRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<MealModel>> getMeals() async {
    final userId = _supabase.auth.currentUser!.id;

    final response = await _supabase
        .from('meals')
        .select()
        .eq('user_id', userId)
        .order('logged_at', ascending: false);

    return response.map<MealModel>((json) => MealModel.fromJson(json)).toList();
  }

  @override
  Future<void> addMeal(MealModel meal) async {
    await _supabase.from('meals').insert(meal.toInsertJson());
  }

  @override
  Future<int> getTodayCalories() async {
    final userId = _supabase.auth.currentUser!.id;

    final today = DateTime.now().toIso8601String().split('T').first;

    final response = await _supabase
        .from('meals')
        .select('calories')
        .eq('user_id', userId)
        .gte('logged_at', '${today}T00:00:00')
        .lt('logged_at', '${today}T23:59:59');

    int total = 0;

    for (final item in response) {
      total += (item['calories'] as num).toInt();
    }

    return total;
  }
}
