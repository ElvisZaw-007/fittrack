import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/meal_entity.dart';
import '../providers/meal_action_notifier.dart';

class EditMealBottomSheet extends ConsumerStatefulWidget {
  final MealEntity meal;

  const EditMealBottomSheet({super.key, required this.meal});

  @override
  ConsumerState<EditMealBottomSheet> createState() =>
      _EditMealBottomSheetState();
}

class _EditMealBottomSheetState extends ConsumerState<EditMealBottomSheet> {
  late final TextEditingController _mealNameController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _mealNameController = TextEditingController(text: widget.meal.mealName);
    _caloriesController = TextEditingController(
      text: widget.meal.calories.toString(),
    );
    _proteinController = TextEditingController(
      text: widget.meal.proteinG.toString(),
    );
    _carbsController = TextEditingController(
      text: widget.meal.carbsG.toString(),
    );
    _fatController = TextEditingController(text: widget.meal.fatG.toString());
    _notesController = TextEditingController(text: widget.meal.notes ?? '');
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final mealName = _mealNameController.text.trim();
    final calories = int.tryParse(_caloriesController.text.trim());
    final protein = double.tryParse(_proteinController.text.trim()) ?? 0;
    final carbs = double.tryParse(_carbsController.text.trim()) ?? 0;
    final fat = double.tryParse(_fatController.text.trim()) ?? 0;
    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    if (mealName.isEmpty) {
      _showSnackBar('Meal name is required');
      return;
    }

    if (calories == null || calories <= 0) {
      _showSnackBar('Enter valid calories');
      return;
    }

    final updatedMeal = MealEntity(
      id: widget.meal.id,
      mealName: mealName,
      calories: calories,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
      loggedAt: widget.meal.loggedAt,
      notes: notes,
    );

    await ref.read(mealActionProvider.notifier).updateMeal(updatedMeal);

    final state = ref.read(mealActionProvider);

    if (state.hasError) {
      if (mounted) {
        _showSnackBar(state.error.toString());
      }
      return;
    }

    if (mounted) {
      Navigator.pop(context);
      _showSnackBar('Meal updated');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mealActionProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Edit Meal',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _proteinController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Protein (g)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _carbsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Carbs (g)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _fatController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Fat (g)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: state.isLoading ? null : _submit,
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Update Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
