import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/huly_theme.dart';
import '../../core/widgets/huly_button.dart';
import 'auth_provider.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-prompt biometrics on screen load.
    Future.microtask(
        () => ref.read(authProvider.notifier).unlockWithBiometrics());
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: HulyColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline,
                    color: HulyColors.accent, size: 64),
                const SizedBox(height: 24),
                Text(
                  'Huly is locked',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Authenticate to continue',
                  style: TextStyle(color: HulyColors.darkerText, fontSize: 14),
                ),
                const SizedBox(height: 32),
                if (auth.error != null) ...[
                  Text(auth.error!,
                      style: const TextStyle(color: HulyColors.errorText)),
                  const SizedBox(height: 16),
                ],
                HulyButton(
                  label: 'Unlock',
                  onPressed: () =>
                      ref.read(authProvider.notifier).unlockWithBiometrics(),
                ),
                const SizedBox(height: 16),
                HulyButton(
                  label: 'Sign out',
                  kind: HulyButtonKind.ghost,
                  onPressed: () => ref.read(authProvider.notifier).logout(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
