import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../providers/weight_log_notifiers.dart';
import '../widgets/add_weight_log_sheet.dart';

class WeightLogPage extends ConsumerStatefulWidget {
  const WeightLogPage({super.key});

  @override
  ConsumerState<WeightLogPage> createState() => _WeightLogPageState();
}

class _WeightLogPageState extends ConsumerState<WeightLogPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(weightLogActionProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (previous?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Operation completed')),
            );
          }
        },
        error: (error, _) {
          String message = 'Something went wrong';

          if (error is ServerFailure) {
            message = error.message;
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
      );
    });

    final history = ref.watch(weightHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Weight Logs')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const AddWeightLogSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, _) => Center(child: Text(error.toString())),

        data: (logs) {
          if (logs.isEmpty) {
            return const Center(child: Text('No weight logs yet'));
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];

              return Dismissible(
                key: ValueKey(log.id),

                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                ),

                onDismissed: (_) {
                  if (log.id != null) {
                    ref
                        .read(weightLogActionProvider.notifier)
                        .deleteLog(log.id!);
                  }
                },

                child: ListTile(
                  title: Text('${log.weightKg} kg'),

                  subtitle: Text(
                    '${log.loggedAt.day}/${log.loggedAt.month}/${log.loggedAt.year}',
                  ),

                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => AddWeightLogSheet(initialLog: log),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
