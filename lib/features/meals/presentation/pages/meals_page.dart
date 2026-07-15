//lib/meals/presentation/pages/meals.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/meal_providers.dart';
import '../../domain/entities/meal_entity.dart';
import '../widgets/add_meal_bottom_sheet.dart';
import '../widgets/delete_meal_bottom_sheet.dart';
import '../widgets/edit_meal_bottom_sheet.dart';
import 'package:fittrack/core/widgets/loading_view.dart';
import 'package:fittrack/core/widgets/error_view.dart';
import 'package:fittrack/core/widgets/empty_state_view.dart';

class MealsPage extends ConsumerWidget {
  const MealsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsync = ref.watch(mealsProvider);
    final todayCaloriesAsync = ref.watch(todayCaloriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        actions: [
          todayCaloriesAsync.when(
            data: (calories) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Chip(
                avatar: const Icon(Icons.local_fire_department, size: 18),
                label: Text('$calories kcal'),
                backgroundColor: Colors.orange.shade100,
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: mealsAsync.when(
        data: (meals) => meals.isEmpty
            ? EmptyStateView(
                icon: Icons.restaurant,
                title: 'No meals yet',
                message: 'Fuel your journey — add your first meal.',
                actionLabel: 'Add Meal',
                onAction: () => _showAddMealSheet(context),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: meals.length,
                itemBuilder: (context, index) => _MealCard(meal: meals[index]),
              ),
        loading: () => const LoadingView(message: 'Loading meals...'),
        error: (error, stackTrace) => ErrorView(
          message: 'Unable to load your meals.',
          onRetry: () => ref.invalidate(mealsProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMealSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMealSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddMealBottomSheet(),
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealEntity meal;

  const _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showMealDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.mealName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(meal.loggedAt),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  _buildCalorieChip(),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(context, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (meal.notes != null && meal.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  meal.notes!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (_hasMacros) ...[const SizedBox(height: 8), _buildMacroRow()],
            ],
          ),
        ),
      ),
    );
  }

  bool get _hasMacros =>
      (meal.proteinG > 0) || (meal.carbsG > 0) || (meal.fatG > 0);

  Widget _buildCalorieChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Text(
        '${meal.calories} kcal',
        style: TextStyle(
          color: Colors.orange.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildMacroRow() {
    return Row(
      children: [
        if (meal.proteinG > 0)
          _MacroBadge(
            label: 'P',
            value: meal.proteinG,
            color: Colors.red.shade100,
            textColor: Colors.red.shade800,
          ),
        if (meal.carbsG > 0) ...[
          const SizedBox(width: 6),
          _MacroBadge(
            label: 'C',
            value: meal.carbsG,
            color: Colors.blue.shade100,
            textColor: Colors.blue.shade800,
          ),
        ],
        if (meal.fatG > 0) ...[
          const SizedBox(width: 6),
          _MacroBadge(
            label: 'F',
            value: meal.fatG,
            color: Colors.yellow.shade100,
            textColor: Colors.yellow.shade800,
          ),
        ],
      ],
    );
  }

  void _showMealDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meal.mealName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            _detailRow('Calories', '${meal.calories} kcal'),
            if (meal.proteinG > 0) _detailRow('Protein', '${meal.proteinG}g'),
            if (meal.carbsG > 0) _detailRow('Carbs', '${meal.carbsG}g'),
            if (meal.fatG > 0) _detailRow('Fat', '${meal.fatG}g'),
            _detailRow('Date', _formatDate(meal.loggedAt)),
            if (meal.notes != null && meal.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Notes', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(meal.notes!),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditSheet(context);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showDeleteSheet(context);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String value) {
    switch (value) {
      case 'edit':
        _showEditSheet(context);
      case 'delete':
        _showDeleteSheet(context);
    }
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => EditMealBottomSheet(meal: meal),
    );
  }

  void _showDeleteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => DeleteMealBottomSheet(meal: meal),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) return 'Today';
    if (dateToCheck == yesterday) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _MacroBadge extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final Color textColor;

  const _MacroBadge({
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: ${value.toStringAsFixed(1)}g',
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
