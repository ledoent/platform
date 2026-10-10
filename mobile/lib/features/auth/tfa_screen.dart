import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/huly_theme.dart';
import '../../core/widgets/huly_button.dart';
import 'auth_provider.dart';

class TfaScreen extends ConsumerStatefulWidget {
  const TfaScreen({super.key});

  @override
  ConsumerState<TfaScreen> createState() => _TfaScreenState();
}

class _TfaScreenState extends ConsumerState<TfaScreen> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    await ref.read(authProvider.notifier).verify2fa(code);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: HulyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),
              Text(
                'Two-Factor Authentication',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter the 6-digit code from your authenticator app',
                style: TextStyle(
                  color: HulyColors.darkerText,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextFormField(
                controller: _codeController,
                decoration: hulyInputDecoration('Authentication code'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: 8,
                ),
                autofocus: true,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              if (auth.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    auth.error!,
                    style: const TextStyle(color: HulyColors.errorText),
                  ),
                ),
              HulyButton(
                label: 'Verify',
                onPressed: _submit,
                loading: auth.loading,
              ),
              const SizedBox(height: 24),
              HulyButton(
                label: 'Back to login',
                kind: HulyButtonKind.ghost,
                onPressed: () => ref.read(authProvider.notifier).logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
