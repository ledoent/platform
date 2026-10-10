import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/huly_theme.dart';
import '../auth/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: HulyColors.background,
      appBar: AppBar(
        backgroundColor: HulyColors.header,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsSection(
            title: 'Connection',
            children: [
              _SettingsTile(
                icon: Icons.dns_outlined,
                label: 'Server',
                value: auth.serverUrl ?? 'Not set',
              ),
              _SettingsTile(
                icon: Icons.workspaces_outlined,
                label: 'Workspace',
                value: auth.workspaceLogin?.workspaceUrl ?? 'Not selected',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'Security',
            children: [
              _SettingsTile(
                icon: Icons.fingerprint,
                label: 'Biometric lock',
                trailing: Switch.adaptive(
                  value: auth.biometricEnabled,
                  onChanged: (value) =>
                      ref.read(authProvider.notifier).setBiometricEnabled(value),
                  activeColor: HulyColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'Account',
            children: [
              _SettingsTile(
                icon: Icons.logout,
                label: 'Sign out',
                onTap: () => ref.read(authProvider.notifier).logout(),
                isDestructive: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Huly Mobile v0.2.0',
              style: TextStyle(
                color: HulyColors.darkerText,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: HulyColors.darkerText,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: HulyColors.listRow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool isDestructive;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.isDestructive = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? HulyColors.negative : HulyColors.contentText;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: TextStyle(color: color, fontSize: 15)),
            ),
            if (trailing != null) trailing!,
            if (trailing == null && value != null)
              Flexible(
                child: Text(
                  value!,
                  style: const TextStyle(
                      color: HulyColors.darkerText, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            if (trailing == null && onTap != null && value == null)
              const Icon(Icons.chevron_right, color: HulyColors.darkerText),
          ],
        ),
      ),
    );
  }
}
