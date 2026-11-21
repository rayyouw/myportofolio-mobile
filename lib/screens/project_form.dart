import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/form_text_field.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Screen with a form for entering a new portfolio project.
class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _technologiesController = TextEditingController();
  final _linkController = TextEditingController();
  String _category = 'Web Development'; // default
  int _resetCount =
      0; // changing the key rebuilds the dropdown with its default

  final List<String> _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _technologiesController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _descriptionController.clear();
    _technologiesController.clear();
    _linkController.clear();
    setState(() {
      _category = _categories.first;
      _resetCount++;
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Project added successfully!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Project Name: ${_nameController.text.trim()}'),
                Text('Description: ${_descriptionController.text.trim()}'),
                Text('Category: $_category'),
                Text('Technologies: ${_technologiesController.text.trim()}'),
                Text('Link: ${_linkController.text.trim()}'),
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
                label: 'Project Name',
                controller: _nameController,
                validator: Validators.combine([
                  Validators.required('Project name'),
                  Validators.length('Project name', max: 100),
                ]),
              ),
              FormTextField(
                label: 'Project Description',
                controller: _descriptionController,
                maxLines: 5,
                validator: Validators.combine([
                  Validators.required('Project description'),
                  Validators.length('Project description', max: 500),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  key: ValueKey(_resetCount),
                  decoration: InputDecoration(
                    labelText: 'Project Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() => _category = newValue!);
                  },
                ),
              ),
              FormTextField(
                label: 'Technologies Used',
                hint: 'Example: Flutter, Django, Figma',
                controller: _technologiesController,
              ),
              FormTextField(
                label: 'Project Link',
                hint: 'Project URL (optional)',
                controller: _linkController,
                keyboardType: TextInputType.url,
                validator: Validators.url,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _save,
                    child: const Text(
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
