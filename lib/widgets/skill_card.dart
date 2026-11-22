import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/skill.dart';

/// Card summarising one [Skill], with an optional delete button.
class SkillCard extends StatelessWidget {
  final Skill skill;
  final VoidCallback? onDelete;

  const SkillCard({super.key, required this.skill, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          child: Icon(Icons.psychology),
        ),
        title: Text(skill.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${skill.category} - ${skill.level}'),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: skill.levelRank / skillLevels.length,
              color: Colors.orange,
              minHeight: 6,
            ),
            if (skill.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(skill.description),
            ],
          ],
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
