import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/education.dart';

/// Card summarising one [Education] entry, with an optional delete button.
class EducationCard extends StatelessWidget {
  final Education education;
  final VoidCallback? onDelete;

  const EducationCard({super.key, required this.education, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final gpa = education.gpa;
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          child: Icon(Icons.school),
        ),
        title: Text(education.institution),
        subtitle: Text(
          '${education.level} - ${education.major}\n${education.period}'
          '${gpa == null ? '' : '\nGPA ${gpa.toStringAsFixed(2)}'}',
        ),
        isThreeLine: true,
        trailing: onDelete == null
            ? null
            : IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
              ),
      ),
    );
  }
}
