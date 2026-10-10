import 'package:flutter/material.dart';
import '../theme/huly_theme.dart';
import 'priority_icon.dart';

class PriorityChip extends StatelessWidget {
  final int priority;
  final bool selected;
  final VoidCallback onTap;

  const PriorityChip({
    super.key,
    required this.priority,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = HulyColors.priorityColor(priority);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              selected ? color.withValues(alpha: 0.2) : HulyColors.inputFill,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PriorityIcon(priority: priority, size: 16),
            const SizedBox(width: 6),
            Text(
              PriorityIcon.label(priority),
              style: TextStyle(
                color: selected ? color : HulyColors.darkText,
                fontSize: 13,
                fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
