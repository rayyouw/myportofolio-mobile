import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/form_text_field.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Screen with a form that creates a new project through the REST API.
class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _techStackController = TextEditingController();
  final _projectUrlController = TextEditingController();
  final _projectImageUrlController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _techStackController.dispose();
    _projectUrlController.dispose();
    _projectImageUrlController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _titleController.clear();
    _descriptionController.clear();
    _techStackController.clear();
    _projectUrlController.clear();
    _projectImageUrlController.clear();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
  }

  Future<void> _submit({bool isRetry = false}) async {
    if (!_formKey.currentState!.validate()) return;
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final token = context.read<AuthState>().token!;
    final newProject = Project(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      techStack: _techStackController.text.trim(),
      projectUrl: _projectUrlController.text.trim(),
      projectImageUrl: _projectImageUrlController.text.trim(),
    );

    setState(() => _isSubmitting = true);
    try {
      final created = await context.read<ApiClient>().createProject(
        newProject,
        token: token,
      );
      if (!mounted) return;
      _showSuccessDialog(created);
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        // The token is no longer valid: drop it and ask for a new login.
        await context.read<AuthState>().logout();
        if (!mounted) return;
        _showError('Your session has expired. Please log in again.');
        setState(() => _isSubmitting = false);
        if (!isRetry) await _submit(isRetry: true);
        return;
      }
      _showError(
        e.statusCode == 403
            ? 'Only the portfolio owner can add projects (403).'
            : 'Failed to save project (${e.statusCode}).',
      );
    } catch (_) {
      if (!mounted) return;
      _showError('Could not reach the server.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showSuccessDialog(Project project) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Project added successfully!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${project.title}'),
                Text('Description: ${project.description}'),
                Text('Tech Stack: ${project.techStack}'),
                Text('Project URL: ${project.projectUrl}'),
                if (project.projectImageUrl.isNotEmpty)
                  Text('Project Image URL: ${project.projectImageUrl}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormTextField(
                label: 'Title',
                controller: _titleController,
                validator: Validators.combine([
                  Validators.required('Title'),
                  Validators.length('Title', max: 255),
                ]),
              ),
              FormTextField(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 5,
                validator: Validators.required('Description'),
              ),
              FormTextField(
                label: 'Tech Stack',
                hint: 'Example: Flutter, Django, PostgreSQL',
                controller: _techStackController,
                validator: Validators.combine([
                  Validators.required('Tech stack'),
                  Validators.length('Tech stack', max: 255),
                ]),
              ),
              FormTextField(
                label: 'Project URL',
                hint: 'https://github.com/username/project',
                controller: _projectUrlController,
                keyboardType: TextInputType.url,
                validator: Validators.combine([
                  Validators.required('Project URL'),
                  Validators.url,
                ]),
              ),
              FormTextField(
                label: 'Project Image URL (Optional)',
                hint: 'https://example.com/screenshot.png',
                controller: _projectImageUrlController,
                keyboardType: TextInputType.url,
                validator: Validators.combine([
                  Validators.length('Project image URL', max: 500),
                  Validators.url,
                ]),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
