import 'goal.dart';

extension GoalProgressX on Goal {
  /// Progress toward the goal given the [currentWeight] from weight_logs.
  /// Returns a value between 0.0 and 1.0.
  double progressPercent(double currentWeight) {
    final total = (targetWeight - startWeight).abs();
    if (total == 0) return 1.0; // maintainWeight goal — already at target

    final achieved = (currentWeight - startWeight).abs();
    return (achieved / total).clamp(0.0, 1.0);
  }

  int get remainingDays {
    final days = targetDate.difference(DateTime.now()).inDays;
    return days < 0 ? 0 : days;
  }
}
