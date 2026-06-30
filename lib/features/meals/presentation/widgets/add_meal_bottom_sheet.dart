import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/meal_entity.dart';
import '../providers/meal_action_notifier.dart';

class AddMealBottomSheet extends ConsumerStatefulWidget {
  const AddMealBottomSheet({super.key});

  @override
  ConsumerState<AddMealBottomSheet> createState() => _AddMealBottomSheetState();
}

class _AddMealBottomSheetState extends ConsumerState<AddMealBottomSheet> {
  final _mealNameController = TextEditingController();
  final _caloriesController = TextEditingController();

  @override
  void dispose() {
    _mealNameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final meal = MealEntity(
      id: '',
      userId: '',
      mealName: _mealNameController.text.trim(),
      calories: int.tryParse(_caloriesController.text.trim()) ?? 0,
      proteinG: 0,
      carbsG: 0,
      fatG: 0,
      loggedAt: DateTime.now(),
      notes: null,
    );

    await ref.read(mealActionNotifierProvider.notifier).addMeal(meal);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mealActionNotifierProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _mealNameController,
            decoration: const InputDecoration(labelText: 'Meal Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _caloriesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Calories'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: state.isLoading ? null : _submit,
            child: state.isLoading
                ? const CircularProgressIndicator()
                : const Text('Add Meal'),
          ),
        ],
      ),
    );
  }
}
