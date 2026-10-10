import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/huly_theme.dart';
import '../../core/widgets/huly_button.dart';
import 'auth_provider.dart';
import 'oauth_webview_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPasswordField = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submitOtpRequest() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).requestOtp(
          _emailController.text.trim(),
        );
  }

  Future<void> _submitOtpCode() async {
    final code = _otpController.text.trim();
    if (code.isEmpty) return;
    await ref.read(authProvider.notifier).validateOtp(code);
  }

  Future<void> _submitPassword() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  Future<void> _loginWithProvider(String provider) async {
    final url = ref.read(authProvider.notifier).getOAuthUrl(provider);
    if (url == null) return;

    final token = await performOAuthLogin(url);

    if (token != null && mounted) {
      await ref.read(authProvider.notifier).loginWithToken(token);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in was cancelled or failed'),
          backgroundColor: HulyColors.negative,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isOtpPending = auth.status == AuthStatus.otpPending;
    final providers = auth.providers ?? [];

    return Scaffold(
      backgroundColor: HulyColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                Text(
                  isOtpPending ? 'Check your email' : 'Sign In',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isOtpPending
                      ? 'Enter the code sent to ${auth.otpEmail}'
                      : auth.serverUrl ?? '',
                  style: const TextStyle(
                    color: HulyColors.darkerText,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                if (isOtpPending) ...[
                  // OTP code entry
                  TextFormField(
                    controller: _otpController,
                    decoration: hulyInputDecoration('Verification code'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      letterSpacing: 8,
                    ),
                    autofocus: true,
                    onFieldSubmitted: (_) => _submitOtpCode(),
                  ),
                  const SizedBox(height: 16),
                  if (auth.error != null) _ErrorText(auth.error!),
                  HulyButton(
                    label: 'Verify',
                    onPressed: _submitOtpCode,
                    loading: auth.loading,
                  ),
                  const SizedBox(height: 12),
                  HulyButton(
                    label: 'Resend code',
                    kind: HulyButtonKind.ghost,
                    onPressed: () {
                      _otpController.clear();
                      ref.read(authProvider.notifier).requestOtp(auth.otpEmail!);
                    },
                  ),
                ] else ...[
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: hulyInputDecoration('Email', 'you@example.com'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    style: const TextStyle(color: HulyColors.contentText),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  if (_showPasswordField) ...[
                    TextFormField(
                      controller: _passwordController,
                      decoration: hulyInputDecoration('Password'),
                      obscureText: true,
                      style: const TextStyle(color: HulyColors.contentText),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Required' : null,
                      onFieldSubmitted: (_) => _submitPassword(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (auth.error != null) _ErrorText(auth.error!),

                  // Primary action
                  if (_showPasswordField) ...[
                    HulyButton(
                      label: 'Sign In',
                      onPressed: _submitPassword,
                      loading: auth.loading,
                    ),
                    const SizedBox(height: 8),
                    HulyButton(
                      label: 'Sign in with email code instead',
                      kind: HulyButtonKind.ghost,
                      onPressed: () => setState(() => _showPasswordField = false),
                    ),
                  ] else ...[
                    HulyButton(
                      label: 'Send sign-in code',
                      onPressed: _submitOtpRequest,
                      loading: auth.loading,
                    ),
                    const SizedBox(height: 8),
                    HulyButton(
                      label: 'Sign in with password instead',
                      kind: HulyButtonKind.ghost,
                      onPressed: () => setState(() => _showPasswordField = true),
                    ),
                  ],

                  // OAuth provider buttons
                  if (providers.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const _Divider(),
                    const SizedBox(height: 24),
                    for (final provider in providers)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: OutlinedButton.icon(
                          onPressed: auth.loading
                              ? null
                              : () => _loginWithProvider(provider.id),
                          icon: Icon(_providerIcon(provider.id), size: 22),
                          label: Text('Continue with ${_providerLabel(provider.id)}'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: HulyColors.contentText,
                            side: const BorderSide(color: HulyColors.divider),
                            backgroundColor: HulyColors.inputFill,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                  ],
                ],

                const SizedBox(height: 24),
                HulyButton(
                  label: 'Change server',
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

IconData _providerIcon(String id) {
  switch (id) {
    case 'google':
      return Icons.g_mobiledata;
    case 'github':
      return Icons.code;
    case 'openid':
      return Icons.lock_open;
    default:
      return Icons.login;
  }
}

String _providerLabel(String id) {
  switch (id) {
    case 'google':
      return 'Google';
    case 'github':
      return 'GitHub';
    case 'openid':
      return 'SSO';
    default:
      return id[0].toUpperCase() + id.substring(1);
  }
}

class _ErrorText extends StatelessWidget {
  final String text;
  const _ErrorText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(text, style: const TextStyle(color: HulyColors.errorText)),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: HulyColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(color: HulyColors.darkerText, fontSize: 13),
          ),
        ),
        Expanded(child: Divider(color: HulyColors.divider)),
      ],
    );
  }
}
