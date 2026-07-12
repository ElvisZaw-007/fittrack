import 'dart:io';

import 'package:fittrack/features/meals/data/data_source/meal_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/meal_repository.dart';
import '../models/meal_model.dart';

class MealRepositoryImpl implements MealRepository {
  final MealRemoteDataSource remoteDataSource;

  const MealRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addMeal(MealEntity meal) async {
    try {
      await remoteDataSource.addMeal(MealModel.fromEntity(meal));
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<MealEntity>> getMeals() async {
    try {
      final meals = await remoteDataSource.getMeals();
      return meals.map((e) => e.toEntity()).toList();
    } on SocketException {
      throw const NetworkFailure();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<int> getTodayCalories() async {
    try {
      return await remoteDataSource.getTodayCalories();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> deleteMeal(String mealId) async {
    try {
      await remoteDataSource.deleteMeal(mealId);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> updateMeal(MealEntity meal) async {
    try {
      await remoteDataSource.updateMeal(MealModel.fromEntity(meal));
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
