import 'package:flutter/material.dart';
import '../theme/huly_theme.dart';

enum HulyButtonKind { primary, ghost, positive, negative }

class HulyButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final HulyButtonKind kind;
  final bool loading;
  final IconData? icon;

  const HulyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.kind = HulyButtonKind.primary,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              )
            : Text(label);

    switch (kind) {
      case HulyButtonKind.primary:
        return FilledButton(
          onPressed: loading ? null : onPressed,
          style: hulyPrimaryButtonStyle(),
          child: child,
        );
      case HulyButtonKind.ghost:
        return TextButton(
          onPressed: loading ? null : onPressed,
          style: hulyGhostButtonStyle(),
          child: child,
        );
      case HulyButtonKind.positive:
        return FilledButton(
          onPressed: loading ? null : onPressed,
          style: hulyPrimaryButtonStyle().copyWith(
            backgroundColor: WidgetStatePropertyAll(HulyColors.positive),
          ),
          child: child,
        );
      case HulyButtonKind.negative:
        return FilledButton(
          onPressed: loading ? null : onPressed,
          style: hulyPrimaryButtonStyle().copyWith(
            backgroundColor: WidgetStatePropertyAll(HulyColors.negative),
          ),
          child: child,
        );
    }
  }
}
