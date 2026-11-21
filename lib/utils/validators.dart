/// Signature shared by all form validators in the app.
typedef Validator = String? Function(String? value);

/// Reusable validation rules used by the portfolio forms.
///
/// Every rule returns `null` when the value is valid and an error message
/// otherwise, which is the contract expected by `FormField.validator`.
class Validators {
  Validators._();

  /// Rejects `null`, empty and whitespace-only values.
  static Validator required(String label) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return '$label is required.';
      }
      return null;
    };
  }

  /// Rejects values whose trimmed length is outside [min]..[max].
  ///
  /// Empty values pass, so combine with [required] for mandatory fields.
  static Validator length(String label, {int min = 0, required int max}) {
    return (String? value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) return null;
      if (text.length < min) {
        return '$label must be at least $min characters.';
      }
      if (text.length > max) {
        return '$label must be at most $max characters.';
      }
      return null;
    };
  }

  /// Accepts an optional http(s) URL such as `https://example.com/demo`.
  static String? url(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    final valid =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.contains('.');
    return valid ? null : 'Enter a valid URL starting with http:// or https://';
  }

  /// Accepts an optional GPA between 0.00 and 4.00 (comma or dot decimal).
  static String? gpa(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final number = double.tryParse(text.replaceAll(',', '.'));
    if (number == null) return 'GPA must be a number, e.g. 3.75.';
    if (number < 0 || number > 4) return 'GPA must be between 0.00 and 4.00.';
    return null;
  }

  /// Checks that a date was picked.
  static String? requiredDate(DateTime? value, String label) {
    return value == null ? 'Pick the $label.' : null;
  }

  /// Checks that [end] is not before [start].
  static String? dateOrder(DateTime? start, DateTime? end) {
    if (start == null || end == null) return null;
    return end.isBefore(start)
        ? 'End date cannot be before the start date.'
        : null;
  }

  /// Runs [validators] in order and returns the first error found.
  static Validator combine(List<Validator> validators) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
