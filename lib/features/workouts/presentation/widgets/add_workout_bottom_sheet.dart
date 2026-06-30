import 'package:fittrack/features/workouts/domain/entities/workout_entity.dart';
import 'package:fittrack/features/workouts/presentation/providers/workout_action_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWorkoutBottomSheet extends ConsumerStatefulWidget {
  const AddWorkoutBottomSheet({super.key});

  @override
  ConsumerState<AddWorkoutBottomSheet> createState() =>
      _AddWorkoutBottomSheetState();
}

class _AddWorkoutBottomSheetState extends ConsumerState<AddWorkoutBottomSheet> {
  final _titleController = TextEditingController();

  final _durationController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();

    final duration = int.tryParse(_durationController.text.trim());

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Title is required')));
      return;
    }

    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter valid duration')));
      return;
    }

    final workout = WorkoutEntity(
      title: title,
      durationMins: duration,
      caloriesBurned: null,
      loggedAt: DateTime.now(),
      notes: null,
    );

    try {
      await ref
          .read(workoutActionNotifierProvider.notifier)
          .addWorkout(workout);
          
      final state = ref.read(workoutActionNotifierProvider);

      if (state.hasError) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error.toString())));
        }
        return;
      }

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Workout added')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workoutActionNotifierProvider);

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
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Workout Title'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Duration (mins)'),
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
                : const Text('Add Workout'),
          ),
        ],
      ),
    );
  }
}
