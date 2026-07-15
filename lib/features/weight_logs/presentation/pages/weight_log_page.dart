import 'package:fittrack/features/weight_logs/domain/entities/weight_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import 'package:fittrack/core/widgets/loading_view.dart';
import 'package:fittrack/core/widgets/error_view.dart';
import 'package:fittrack/core/widgets/empty_state_view.dart';
import '../providers/weight_log_notifiers.dart';
import '../widgets/add_weight_log_sheet.dart';

class WeightLogPage extends ConsumerStatefulWidget {
  const WeightLogPage({super.key});

  @override
  ConsumerState<WeightLogPage> createState() => _WeightLogPageState();
}

class _WeightLogPageState extends ConsumerState<WeightLogPage> {
  @override
  void initState() {
    super.initState();
    _listenToActions();
  }

  void _listenToActions() {
    ref.listen<AsyncValue<void>>(weightLogActionProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (previous?.isLoading == true) {
            _showSnackBar('Operation completed');
          }
        },
        error: (error, _) {
          final message = error is ServerFailure
              ? error.message
              : 'Something went wrong';
          _showSnackBar(message);
        },
      );
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showAddSheet({WeightLog? initialLog}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddWeightLogSheet(initialLog: initialLog),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(weightHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Weight Logs')),
      body: history.when(
        data: (logs) => logs.isEmpty
            ? EmptyStateView(
                icon: Icons.monitor_weight_outlined,
                title: 'No weight logs yet',
                message: 'Track your progress by logging your first weight.',
                actionLabel: 'Log Weight',
                onAction: () => _showAddSheet(),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: logs.length,
                itemBuilder: (context, index) => _WeightLogTile(
                  log: logs[index],
                  onDelete: (id) =>
                      ref.read(weightLogActionProvider.notifier).deleteLog(id),
                  onEdit: (log) => _showAddSheet(initialLog: log),
                ),
              ),
        loading: () => const LoadingView(message: 'Loading weight history...'),
        error: (error, stackTrace) => ErrorView(
          message: 'Unable to load your weight history.',
          onRetry: () => ref.invalidate(weightHistoryProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _WeightLogTile extends StatelessWidget {
  final WeightLog log;
  final ValueChanged<String> onDelete;
  final ValueChanged<WeightLog> onEdit;

  const _WeightLogTile({
    required this.log,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(log.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        if (log.id != null) onDelete(log.id!);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: const Icon(Icons.monitor_weight_outlined),
          ),
          title: Text(
            '${log.weightKg.toStringAsFixed(1)} kg',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            _formatDate(log.loggedAt),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onEdit(log),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final check = DateTime(date.year, date.month, date.day);

    if (check == today) return 'Today';
    if (check == yesterday) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }
}
