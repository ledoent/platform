import 'package:flutter/material.dart';
import '../theme/huly_theme.dart';

class PriorityIcon extends StatelessWidget {
  final int priority;
  final double size;

  const PriorityIcon({super.key, required this.priority, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Icon(_icon, color: HulyColors.priorityColor(priority), size: size);
  }

  IconData get _icon {
    switch (priority) {
      case 1:
        return Icons.keyboard_double_arrow_up;
      case 2:
        return Icons.keyboard_arrow_up;
      case 3:
        return Icons.remove;
      case 4:
        return Icons.keyboard_arrow_down;
      default:
        return Icons.more_horiz;
    }
  }

  static String label(int priority) {
    switch (priority) {
      case 1:
        return 'Urgent';
      case 2:
        return 'High';
      case 3:
        return 'Medium';
      case 4:
        return 'Low';
      default:
        return 'No priority';
    }
  }
}
