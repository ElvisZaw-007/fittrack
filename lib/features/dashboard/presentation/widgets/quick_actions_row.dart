import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart'; 

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.monitor_weight_outlined,
            label: 'Log Weight',
            onTap: () => context.push(AppRoutes.weightLogs),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.fitness_center,
            label: 'Workouts',
            onTap: () => context.push(AppRoutes.workouts),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.restaurant_outlined,
            label: 'Meals',
            onTap: () => context.push(AppRoutes.meals),
          ),
        ),
      ],
    );
  }
}

// _ActionButton ကိုလည်း ဒီဖိုင်ထဲမှာပဲ တစ်ခါတည်း အောက်ကနေ တွဲရေးထားနိုင်ပါတယ်
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200], 
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: Colors.blue),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}