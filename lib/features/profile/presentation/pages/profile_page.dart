import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fittrack/core/errors/failures.dart';
import '../../domain/entities/profile.dart';
import 'package:fittrack/features/auth/presentation/providers/auth_notifier.dart';
import '../providers/profile_notifier.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _initialized = false;

  UnitPreference _selectedUnit = UnitPreference.metric;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final saveState = ref.watch(saveProfileProvider);
    final authState = ref.watch(authStateProvider);

    ref.listen<AsyncValue<void>>(saveProfileProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved successfully')),
          );
        },
        error: (error, _) {
          final message = switch (error) {
            InvalidProfileFailure() => error.message,
            NetworkFailure() => error.message,
            ServerFailure() => error.message,
            _ => 'Something went wrong.',
          };

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: profileState.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (error, stackTrace) => Center(child: Text(error.toString())),

          data: (profile) {
            if (!_initialized && profile != null) {
              _nameController.text = profile.name;
              _ageController.text = profile.age.toString();
              _heightController.text = profile.heightCm.toString();
              _selectedUnit = profile.unitPreference;

              _initialized = true;
            }

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text(
                      'Your Profile',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                    const SizedBox(height: 24),

                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Age Field
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final age = int.tryParse(value ?? '');

                        if (age == null) {
                          return 'Enter a valid age';
                        }

                        if (age < 10 || age > 120) {
                          return 'Age must be between 10 and 120';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Height Field
                    TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final height = double.tryParse(value ?? '');

                        if (height == null) {
                          return 'Enter a valid height';
                        }

                        if (height < 50 || height > 300) {
                          return 'Height must be between 50 and 300 cm';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Unit Preference
                    DropdownButtonFormField<UnitPreference>(
                      initialValue: _selectedUnit,
                      decoration: const InputDecoration(
                        labelText: 'Unit Preference',
                        border: OutlineInputBorder(),
                      ),
                      items: UnitPreference.values.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedUnit = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    FilledButton(
                      onPressed: saveState.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final userId = authState.when(
                                  data: (user) => user?.id,
                                  loading: () => null,
                                  error: (_, _) => null,
                                );

                                if (userId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Session error. Please log in again.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final updatedProfile = Profile(
                                  userId: userId,
                                  name: _nameController.text.trim(),
                                  age: int.parse(_ageController.text),
                                  heightCm: double.parse(
                                    _heightController.text,
                                  ),
                                  unitPreference: _selectedUnit,
                                );

                                ref
                                    .read(saveProfileProvider.notifier)
                                    .save(updatedProfile);
                              }
                            },
                      child: saveState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save Profile'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
