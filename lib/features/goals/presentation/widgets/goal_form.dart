// lib/features/goals/presentation/widgets/goal_form.dart

import 'package:flutter/material.dart';
import '../../domain/entities/goal.dart';

class CreateGoalForm extends StatefulWidget {
  final Function(Goal) onSubmit;
  final bool isLoading;

  const CreateGoalForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<CreateGoalForm> createState() => _CreateGoalFormState();
}

class _CreateGoalFormState extends State<CreateGoalForm> {
  final _formKey = GlobalKey<FormState>();
  late GoalType _selectedType;
  final _currentWeightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _targetDateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedType = GoalType.loseWeight;
    _targetDateController.addListener(_onDateChanged);
  }

  void _onDateChanged() {
    _formKey.currentState?.validate();
  }

  String? _validateCurrentWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter current weight';
    }
    final weight = double.tryParse(value);
    if (weight == null || weight <= 0) {
      return 'Please enter a valid positive number';
    }
    return null;
  }

  String? _validateTargetWeight(String? value) {
    // For maintainWeight, we don't even show this field
    if (_selectedType == GoalType.maintainWeight) return null;
    
    if (value == null || value.isEmpty) {
      return 'Please enter target weight';
    }
    
    final target = double.tryParse(value);
    if (target == null) {
      return 'Please enter a valid number';
    }
    
    final current = double.tryParse(_currentWeightController.text);
    if (current == null) return null;
    
    switch (_selectedType) {
      case GoalType.loseWeight:
        if (target >= current) {
          return 'Target must be less than current weight for weight loss';
        }
        break;
      case GoalType.gainWeight:
        if (target <= current) {
          return 'Target must be greater than current weight for weight gain';
        }
        break;
      case GoalType.maintainWeight:
        // Already handled above
        break;
    }
    return null;
  }
  
  String? _validateTargetDate(String? value) {
    if (_selectedDate == null) {
      return 'Please select a target date';
    }
    
    final today = DateTime.now();
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    
    if (_selectedDate!.isBefore(tomorrow)) {
      return 'Target date must be at least tomorrow';
    }
    
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _targetDateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
      _formKey.currentState?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<GoalType>(
            initialValue: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Goal Type',
              border: OutlineInputBorder(),
            ),
            items: GoalType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.displayName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedType = value;
                  if (value == GoalType.maintainWeight) {
                    _targetWeightController.clear();
                  }
                });
                _formKey.currentState?.validate();
              }
            },
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _currentWeightController,
            decoration: const InputDecoration(
              labelText: 'Current Weight (kg)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: _validateCurrentWeight,
            onChanged: (_) => _formKey.currentState?.validate(),
          ),
          
          // Conditionally show target weight field
          if (_selectedType != GoalType.maintainWeight) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _targetWeightController,
              decoration: InputDecoration(
                labelText: 'Target Weight (kg)',
                hintText: _selectedType == GoalType.loseWeight 
                    ? 'Must be less than ${_currentWeightController.text.isEmpty ? "current" : _currentWeightController.text}'
                    : 'Must be greater than ${_currentWeightController.text.isEmpty ? "current" : _currentWeightController.text}',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: _validateTargetWeight,
              onChanged: (_) => _formKey.currentState?.validate(),
            ),
          ],
          
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _targetDateController,
            decoration: const InputDecoration(
              labelText: 'Target Date',
              hintText: 'Select a date',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: _validateTargetDate,
          ),
          
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: widget.isLoading ? null : () {
              if (_formKey.currentState?.validate() ?? false) {
                final startWeight = double.parse(_currentWeightController.text);
                final targetWeight = _selectedType == GoalType.maintainWeight
                    ? startWeight
                    : double.parse(_targetWeightController.text);
                
                final goal = Goal(
                  goalType: _selectedType,
                  startWeight: startWeight,
                  targetWeight: targetWeight,
                  startDate: DateTime.now(),
                  targetDate: _selectedDate!,
                );
                
                widget.onSubmit(goal);
              }
            },
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create Goal'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    _targetDateController.dispose();
    super.dispose();
  }
}