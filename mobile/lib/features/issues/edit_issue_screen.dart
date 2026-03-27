import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/html.dart';
import '../../core/models/issue.dart';
import '../../core/models/tx.dart';
import '../../core/theme/huly_theme.dart';
import '../../core/widgets/huly_button.dart';
import '../../core/widgets/priority_chip.dart';
import '../auth/auth_provider.dart';
import 'issue_detail_screen.dart';
import 'issue_provider.dart';

class EditIssueScreen extends ConsumerStatefulWidget {
  final Issue issue;

  const EditIssueScreen({super.key, required this.issue});

  @override
  ConsumerState<EditIssueScreen> createState() => _EditIssueScreenState();
}

class _EditIssueScreenState extends ConsumerState<EditIssueScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late int _priority;
  late String _statusId;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.issue.title);
    final rawDesc = widget.issue.description
            ?.replaceAll(RegExp(r'<[^>]*>'), '')
            .trim() ??
        '';
    _descController = TextEditingController(text: rawDesc);
    _priority = widget.issue.priority;
    _statusId = widget.issue.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final client = ref.read(restClientProvider);
      if (client == null) throw Exception('Not connected');

      final operations = <String, dynamic>{};
      if (title != widget.issue.title) {
        operations['title'] = title;
      }

      final desc = _descController.text.trim();
      final htmlDesc = desc.isEmpty ? '<p></p>' : '<p>${escapeHtml(desc)}</p>';
      final oldDesc = widget.issue.description ?? '<p></p>';
      if (htmlDesc != oldDesc) {
        operations['description'] = htmlDesc;
      }

      if (_priority != widget.issue.priority) {
        operations['priority'] = _priority;
      }

      if (_statusId != widget.issue.status) {
        operations['status'] = _statusId;
      }

      if (operations.isEmpty) {
        if (mounted) context.pop();
        return;
      }

      final tx = buildUpdateIssueTx(
        issueId: widget.issue.id,
        space: widget.issue.space,
        operations: operations,
      );

      await client.tx(tx);

      if (mounted) {
        // Invalidate detail and list providers to reflect changes.
        ref.invalidate(issueDetailProvider(widget.issue.id));
        ref.invalidate(issuesProvider(widget.issue.space));
        context.pop();
      }
    } catch (e) {
      setState(() => _error = 'Failed to update: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusesAsync = ref.watch(issueStatusesProvider);

    return Scaffold(
      backgroundColor: HulyColors.background,
      appBar: AppBar(
        backgroundColor: HulyColors.header,
        title: Text(widget.issue.identifier),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: hulyInputDecoration('Title'),
              style: const TextStyle(color: HulyColors.contentText),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: hulyInputDecoration('Description'),
              style: const TextStyle(color: HulyColors.contentText),
              maxLines: 5,
              minLines: 3,
            ),
            const SizedBox(height: 16),
            // Status dropdown
            if (statusesAsync.valueOrNull != null &&
                statusesAsync.valueOrNull!.isNotEmpty) ...[
              const Text(
                'Status',
                style: TextStyle(
                  color: HulyColors.darkText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _statusId,
                decoration: hulyInputDecoration('Status'),
                dropdownColor: HulyColors.inputFill,
                style: const TextStyle(color: HulyColors.contentText),
                items: statusesAsync.valueOrNull!
                    .map((s) => DropdownMenuItem(
                          value: s.id,
                          child: Text(s.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _statusId = value);
                },
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Priority',
              style: TextStyle(
                color: HulyColors.darkText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in [0, 1, 2, 3, 4])
                  PriorityChip(
                    priority: p,
                    selected: _priority == p,
                    onTap: () => setState(() => _priority = p),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _error!,
                  style: const TextStyle(color: HulyColors.errorText),
                ),
              ),
            HulyButton(
              label: 'Save Changes',
              onPressed: _submit,
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}
