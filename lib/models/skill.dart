/// Proficiency levels a skill can be rated with, from lowest to highest.
const List<String> skillLevels = [
  'Beginner',
  'Intermediate',
  'Advanced',
  'Expert',
];

/// Categories a skill can belong to.
const List<String> skillCategories = [
  'Programming',
  'Framework',
  'Data & AI',
  'Tools',
  'Soft Skill',
];

/// One skill of the portfolio owner.
class Skill {
  final String name;
  final String category;
  final String level;
  final String description;

  const Skill({
    required this.name,
    required this.category,
    required this.level,
    this.description = '',
  });

  /// Position of [level] in [skillLevels], 1 (Beginner) to 4 (Expert).
  int get levelRank {
    final index = skillLevels.indexOf(level);
    return index < 0 ? 1 : index + 1;
  }
}
