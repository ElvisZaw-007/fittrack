import 'package:fittrack/core/errors/failures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/weight_log.dart';
import '../providers/weight_log_notifiers.dart';

class AddWeightLogSheet extends ConsumerStatefulWidget {
  final WeightLog? initialLog;

  const AddWeightLogSheet({super.key, this.initialLog});

  @override
  ConsumerState<AddWeightLogSheet> createState() => _AddWeightLogSheetState();
}

class _AddWeightLogSheetState extends ConsumerState<AddWeightLogSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _weightController;

  late DateTime _selectedDate;

  bool get isEditing => widget.initialLog != null;

  @override
  void initState() {
    super.initState();

    _weightController = TextEditingController(
      text: widget.initialLog?.weightKg.toString() ?? '',
    );

    _selectedDate = widget.initialLog?.loggedAt ?? DateTime.now();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final weight = double.parse(_weightController.text);

    final log = WeightLog(
      id: widget.initialLog?.id,
      weightKg: weight,
      loggedAt: _selectedDate,
      notes: widget.initialLog?.notes,
    );

    if (isEditing) {
      ref.read(weightLogActionProvider.notifier).updateLog(log);
    } else {
      ref.read(weightLogActionProvider.notifier).addLog(log);
    }

    //Only close if the operation succeeded
    if (mounted && !ref.read(weightLogActionProvider).hasError) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mutation = ref.watch(weightLogActionProvider);

    ref.listen<AsyncValue<void>>(weightLogActionProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          // ignore: unused_local_variable
          final message = switch (error) {
            DuplicateWeightLogFailure() =>
              'You already have a weight entry for today.',
            InvalidWeightLogFailure() => error.message,
            NetworkFailure() => 'No internet connection.',
            _ => 'Something went wrong.',
          };
        },
      );
    });

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditing ? 'Edit Weight' : 'Add Weight',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 24),

            TextFormField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter weight';
                }

                final weight = double.tryParse(value);

                if (weight == null || weight <= 0) {
                  return 'Invalid weight';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            ListTile(
              title: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),

            const SizedBox(height: 16),

            FilledButton(
              onPressed: mutation.isLoading ? null : _submit,
              child: mutation.isLoading
                  ? const CircularProgressIndicator()
                  : Text(isEditing ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
