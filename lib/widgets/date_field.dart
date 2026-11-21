import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/utils/formatters.dart';

/// Form field that opens `showDatePicker()` and shows the chosen date.
///
/// The selected date is owned by the parent ([value]); [validator] receives it
/// so that rules spanning several fields (e.g. date order) can be expressed.
class DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String? Function(DateTime? value)? validator;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
  });

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1990),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormField<DateTime>(
        enabled: enabled,
        validator: (_) => validator?.call(value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (state) {
          return InkWell(
            borderRadius: BorderRadius.circular(5.0),
            onTap: enabled
                ? () async {
                    await _pick(context);
                    state.didChange(value);
                  }
                : null,
            child: InputDecorator(
              isEmpty: value == null,
              decoration: InputDecoration(
                labelText: label,
                enabled: enabled,
                errorText: state.errorText,
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text(value == null ? '' : formatDate(value!)),
            ),
          );
        },
      ),
    );
  }
}
