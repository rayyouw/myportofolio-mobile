import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/skill.dart';
import 'package:myportofolio_mobile/screens/skill_list.dart';
import 'package:myportofolio_mobile/state/skill_store.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/form_text_field.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/skill_card.dart';

/// Screen with a form for adding a skill to the portfolio.
class SkillFormPage extends StatefulWidget {
  const SkillFormPage({super.key});

  @override
  State<SkillFormPage> createState() => _SkillFormPageState();
}

class _SkillFormPageState extends State<SkillFormPage> {
  static const int _descriptionLimit = 200;
  static const String _defaultCategory = 'Programming';
  static const String _defaultLevel = 'Beginner';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _category = _defaultCategory;
  String _level = _defaultLevel;

  /// Changing the key rebuilds the dropdowns so they return to their defaults.
  int _resetCount = 0;

  /// True once the user has typed or picked anything.
  bool get _isDirty =>
      _nameController.text.isNotEmpty ||
      _descriptionController.text.isNotEmpty ||
      _category != _defaultCategory ||
      _level != _defaultLevel;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _descriptionController.clear();
    setState(() {
      _category = _defaultCategory;
      _level = _defaultLevel;
      _resetCount++;
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final skill = Skill(
      name: _nameController.text.trim(),
      category: _category,
      level: _level,
      description: _descriptionController.text.trim(),
    );
    skillStore.add(skill);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Skill added successfully!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${skill.name}'),
                Text('Category: ${skill.category}'),
                Text('Level: ${skill.level}'),
                Text(
                  'Description: ${skill.description.isEmpty ? '-' : skill.description}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('View List'),
              onPressed: () {
                Navigator.pop(dialogContext);
                _resetForm();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SkillListPage(),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(dialogContext);
                _resetForm();
              },
            ),
          ],
        );
      },
    );
  }

  /// Asks before leaving with unsaved input. Returns true if leaving is fine.
  Future<bool> _confirmDiscard() async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('The skill you are entering has not been saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        key: ValueKey('$label-$_resetCount'),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        initialValue: value,
        items: options
            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
            .toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (await _confirmDiscard()) navigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Skill Form'),
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
                  label: 'Skill Name',
                  hint: 'Example: Python',
                  controller: _nameController,
                  onChanged: (_) => setState(() {}),
                  validator: Validators.combine([
                    Validators.required('Skill name'),
                    Validators.length('Skill name', min: 2, max: 50),
                    (value) => skillStore.containsName(value ?? '')
                        ? 'This skill is already in your list.'
                        : null,
                  ]),
                ),
                _dropdown(
                  label: 'Category',
                  value: _category,
                  options: skillCategories,
                  onChanged: (v) => setState(() => _category = v),
                ),
                _dropdown(
                  label: 'Proficiency Level',
                  value: _level,
                  options: skillLevels,
                  onChanged: (v) => setState(() => _level = v),
                ),
                FormTextField(
                  label: 'Description',
                  hint: 'Optional: what you built or used it for',
                  controller: _descriptionController,
                  maxLines: 3,
                  maxLength: _descriptionLimit,
                  onChanged: (_) => setState(() {}),
                  validator: Validators.length(
                    'Description',
                    max: _descriptionLimit,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: _isDirty ? _resetForm : null,
                        child: const Text('Reset'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.indigo,
                          ),
                        ),
                        onPressed: _save,
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                ListenableBuilder(
                  listenable: skillStore,
                  builder: (context, _) {
                    final items = skillStore.items;
                    if (items.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Saved Skills (${items.length})',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          for (final item in items)
                            SkillCard(
                              skill: item,
                              onDelete: () => skillStore.remove(item),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
