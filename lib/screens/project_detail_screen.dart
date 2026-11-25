import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Screen showing every attribute of a single [Project].
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final hasImage = project.projectImageUrl.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  project.projectImageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              project.title,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _DetailRow(label: 'Description', value: project.description),
            _DetailRow(label: 'Tech Stack', value: project.techStack),
            _DetailRow(
              label: 'Project URL',
              value: project.projectUrl.isEmpty ? '-' : project.projectUrl,
            ),
            if (hasImage)
              _DetailRow(
                label: 'Project Image URL',
                value: project.projectImageUrl,
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          SelectableText(value),
        ],
      ),
    );
  }
}
