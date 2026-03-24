import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/issue.dart';
import '../../core/models/project.dart';
import '../../core/theme/huly_theme.dart';
import '../../core/utils/html.dart';
import '../../core/widgets/huly_button.dart';
import '../../core/widgets/priority_chip.dart';
import '../issues/issue_provider.dart';
import 'create_issue_provider.dart';

class CreateIssueScreen extends ConsumerStatefulWidget {
  final String? initialTitle;
  final String? initialDescription;

  const CreateIssueScreen({
    super.key,
    this.initialTitle,
    this.initialDescription,
  });

  @override
  ConsumerState<CreateIssueScreen> createState() => _CreateIssueScreenState();
}

class _CreateIssueScreenState extends ConsumerState<CreateIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  int _priority = IssuePriority.noPriority;
  Project? _selectedProject;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descController =
        TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProject == null) return;

    final desc = _descController.text.trim();
    final htmlDesc = desc.isEmpty ? null : '<p>${escapeHtml(desc)}</p>';

    final success = await ref.read(createIssueProvider.notifier).createIssue(
          space: _selectedProject!.id,
          title: _titleController.text.trim(),
          status: _selectedProject!.defaultIssueStatus ?? '',
          priority: _priority,
          description: htmlDesc,
        );

    if (success && mounted) {
      ref.read(createIssueProvider.notifier).reset();
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);
    final createState = ref.watch(createIssueProvider);

    return Scaffold(
      backgroundColor: HulyColors.background,
      appBar: AppBar(
        backgroundColor: HulyColors.header,
        title: const Text('New Issue'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Project picker
              projectsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error loading projects: $e',
                    style: const TextStyle(color: HulyColors.errorText)),
                data: (projects) {
                  if (_selectedProject == null && projects.isNotEmpty) {
                    _selectedProject = projects.first;
                  }
                  return DropdownButtonFormField<Project>(
                    initialValue: _selectedProject,
                    dropdownColor: HulyColors.inputFill,
                    style: const TextStyle(color: HulyColors.contentText),
                    decoration: hulyInputDecoration('Project'),
                    items: projects
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.name),
                            ))
                        .toList(),
                    onChanged: (p) => setState(() => _selectedProject = p),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: hulyInputDecoration('Title'),
                style: const TextStyle(color: HulyColors.contentText),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descController,
                decoration: hulyInputDecoration('Description'),
                style: const TextStyle(color: HulyColors.contentText),
                maxLines: 5,
                minLines: 3,
              ),
              const SizedBox(height: 16),

              // Priority — chip-style picker
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

              if (createState.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    createState.error!,
                    style: const TextStyle(color: HulyColors.errorText),
                  ),
                ),

              HulyButton(
                label: 'Create Issue',
                onPressed: _submit,
                loading: createState.loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

