import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_list.dart';
import 'package:myportofolio_mobile/state/education_store.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/date_field.dart';
import 'package:myportofolio_mobile/widgets/education_card.dart';
import 'package:myportofolio_mobile/widgets/form_text_field.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Screen with a form for adding an education entry to the portfolio.
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  static const int _descriptionLimit = 300;

  final _formKey = GlobalKey<FormState>();

  final _institutionController = TextEditingController();
  final _majorController = TextEditingController();
  final _gpaController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _levels = ['High School', 'D3', 'S1', 'S2', 'S3'];
  String _level = 'S1';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _ongoing = false;

  /// Changing the key rebuilds the dropdown so it returns to its default.
  int _resetCount = 0;

  /// True once the user has typed or picked anything.
  bool get _isDirty =>
      _institutionController.text.isNotEmpty ||
      _majorController.text.isNotEmpty ||
      _gpaController.text.isNotEmpty ||
      _descriptionController.text.isNotEmpty ||
      _startDate != null ||
      _endDate != null ||
      _ongoing ||
      _level != 'S1';

  @override
  void dispose() {
    _institutionController.dispose();
    _majorController.dispose();
    _gpaController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _institutionController.clear();
    _majorController.clear();
    _gpaController.clear();
    _descriptionController.clear();
    setState(() {
      _level = 'S1';
      _startDate = null;
      _endDate = null;
      _ongoing = false;
      _resetCount++;
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final gpaText = _gpaController.text.trim();
    final education = Education(
      institution: _institutionController.text.trim(),
      level: _level,
      major: _majorController.text.trim(),
      startDate: _startDate!,
      endDate: _ongoing ? null : _endDate,
      gpa: gpaText.isEmpty ? null : double.parse(gpaText.replaceAll(',', '.')),
      description: _descriptionController.text.trim(),
    );
    educationStore.add(education);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Education added successfully!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Institution: ${education.institution}'),
                Text('Level: ${education.level}'),
                Text('Major: ${education.major}'),
                Text('Period: ${education.period}'),
                Text(
                  'GPA: ${education.gpa == null ? '-' : education.gpa!.toStringAsFixed(2)}',
                ),
                Text(
                  'Description: ${education.description.isEmpty ? '-' : education.description}',
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
                    builder: (context) => const EducationListPage(),
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
        content: const Text(
          'The education you are entering has not been saved.',
        ),
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
          title: const Text('Add Education Form'),
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
                // === Institution ===
                FormTextField(
                  label: 'Institution',
                  hint: 'Example: Universitas Indonesia',
                  controller: _institutionController,
                  onChanged: (_) => setState(() {}),
                  validator: Validators.combine([
                    Validators.required('Institution'),
                    Validators.length('Institution', min: 2, max: 100),
                  ]),
                ),

                // === Level ===
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    key: ValueKey(_resetCount),
                    decoration: InputDecoration(
                      labelText: 'Education Level',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    initialValue: _level,
                    items: _levels
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ),
                        )
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() => _level = newValue!);
                    },
                  ),
                ),

                // === Major ===
                FormTextField(
                  label: 'Major',
                  hint: 'Example: Computer Science',
                  controller: _majorController,
                  onChanged: (_) => setState(() {}),
                  validator: Validators.combine([
                    Validators.required('Major'),
                    Validators.length('Major', min: 2, max: 100),
                  ]),
                ),

                // === Start Date ===
                DateField(
                  label: 'Start Date',
                  value: _startDate,
                  lastDate: DateTime.now(),
                  onChanged: (date) => setState(() => _startDate = date),
                  validator: (date) =>
                      Validators.requiredDate(date, 'start date'),
                ),

                // === Ongoing checkbox ===
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Still studying here'),
                  value: _ongoing,
                  onChanged: (checked) {
                    setState(() {
                      _ongoing = checked ?? false;
                      if (_ongoing) _endDate = null;
                    });
                  },
                ),

                // === End Date ===
                DateField(
                  label: 'End Date',
                  value: _endDate,
                  enabled: !_ongoing,
                  onChanged: (date) => setState(() => _endDate = date),
                  validator: (date) {
                    if (_ongoing) return null;
                    return Validators.requiredDate(date, 'end date') ??
                        Validators.dateOrder(_startDate, date);
                  },
                ),

                // === GPA ===
                FormTextField(
                  label: 'GPA',
                  hint: 'Optional, 0.00 - 4.00',
                  controller: _gpaController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  onChanged: (_) => setState(() {}),
                  validator: Validators.gpa,
                ),

                // === Description ===
                FormTextField(
                  label: 'Description',
                  hint: 'Optional: achievements, activities, thesis topic',
                  controller: _descriptionController,
                  maxLines: 4,
                  maxLength: _descriptionLimit,
                  onChanged: (_) => setState(() {}),
                  validator: Validators.length(
                    'Description',
                    max: _descriptionLimit,
                  ),
                ),

                // === Buttons ===
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
                // === Saved entries ===
                ListenableBuilder(
                  listenable: educationStore,
                  builder: (context, _) {
                    final items = educationStore.items;
                    if (items.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Saved Education (${items.length})',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          for (var i = 0; i < items.length; i++)
                            EducationCard(
                              education: items[i],
                              onDelete: () => educationStore.removeAt(i),
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
