import 'package:myportofolio_mobile/utils/formatters.dart';

/// One education entry of the portfolio owner.
class Education {
  final String institution;
  final String level;
  final String major;
  final DateTime startDate;

  /// `null` while the education is still ongoing.
  final DateTime? endDate;
  final double? gpa;
  final String description;

  const Education({
    required this.institution,
    required this.level,
    required this.major,
    required this.startDate,
    this.endDate,
    this.gpa,
    this.description = '',
  });

  bool get isOngoing => endDate == null;

  /// Human readable period, e.g. `1 Aug 2023 - Present`.
  String get period =>
      '${formatDate(startDate)} - ${endDate == null ? 'Present' : formatDate(endDate!)}';
}
