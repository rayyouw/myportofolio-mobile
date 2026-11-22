import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/skill.dart';
import 'package:myportofolio_mobile/state/skill_store.dart';

Skill skill(String name, String level) =>
    Skill(name: name, category: 'Programming', level: level);

void main() {
  late SkillStore store;
  setUp(() => store = SkillStore());

  test('lists the highest level first, then alphabetically', () {
    final dart = skill('Dart', 'Advanced');
    final python = skill('Python', 'Expert');
    final c = skill('C', 'Advanced');
    store
      ..add(dart)
      ..add(python)
      ..add(c);
    expect(store.items, [python, c, dart]);
  });

  test('containsName ignores case and surrounding spaces', () {
    store.add(skill('Flutter', 'Beginner'));
    expect(store.containsName('  flutter '), isTrue);
    expect(store.containsName('Django'), isFalse);
  });

  test('levelRank maps levels to 1..4', () {
    expect(skill('A', 'Beginner').levelRank, 1);
    expect(skill('A', 'Expert').levelRank, 4);
  });

  test('notifies listeners on add, remove and clear', () {
    var calls = 0;
    store.addListener(() => calls++);
    final s = skill('A', 'Beginner');
    store
      ..add(s)
      ..remove(s)
      ..remove(s) // nothing left to remove: no notification
      ..clear();
    expect(calls, 3);
  });
}
