import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/models/skill.dart';

/// In-memory list of skills shared between screens.
///
/// Skills are kept sorted by proficiency (highest first), then by name, so
/// every screen shows them in the same order.
class SkillStore extends ChangeNotifier {
  final List<Skill> _items = [];

  List<Skill> get items => List.unmodifiable(_items);

  /// True if a skill with the same name already exists (ignoring case).
  bool containsName(String name) {
    final wanted = name.trim().toLowerCase();
    return _items.any((s) => s.name.toLowerCase() == wanted);
  }

  void add(Skill skill) {
    _items.add(skill);
    _items.sort((a, b) {
      final byLevel = b.levelRank.compareTo(a.levelRank);
      return byLevel != 0
          ? byLevel
          : a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    notifyListeners();
  }

  void remove(Skill skill) {
    if (_items.remove(skill)) notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// App-wide instance used by the skill screens.
final SkillStore skillStore = SkillStore();
