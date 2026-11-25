import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/state/skill_store.dart';

import 'helpers/fake_api.dart';

Future<void> useTallScreen(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Finder nameField() => find.widgetWithText(TextFormField, 'Skill Name');

void main() {
  setUp(skillStore.clear);

  testWidgets('Save with empty name shows an error and saves nothing', (
    tester,
  ) async {
    await useTallScreen(tester);
    await tester.pumpWidget(const MaterialApp(home: SkillFormPage()));

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Skill name is required.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    expect(skillStore.items, isEmpty);
  });

  testWidgets('a valid skill is saved, shown in the dialog and listed', (
    tester,
  ) async {
    await useTallScreen(tester);
    await tester.pumpWidget(const MaterialApp(home: SkillFormPage()));

    await tester.enterText(nameField(), '  Python  ');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Skill added successfully!'), findsOneWidget);
    expect(skillStore.items.single.name, 'Python');

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Saved Skills (1)'), findsOneWidget);
    expect(find.text('Python'), findsOneWidget);
    // The form is cleared for the next entry.
    expect(tester.widget<TextFormField>(nameField()).controller!.text, isEmpty);
  });

  testWidgets('a duplicate skill name is rejected', (tester) async {
    await useTallScreen(tester);
    await tester.pumpWidget(const MaterialApp(home: SkillFormPage()));

    for (final name in ['Python', ' python ']) {
      await tester.enterText(nameField(), name);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      if (find.text('OK').evaluate().isNotEmpty) {
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
      }
    }

    expect(skillStore.items, hasLength(1));
  });

  testWidgets('leaving with unsaved input asks for confirmation', (
    tester,
  ) async {
    await useTallScreen(tester);
    await tester.pumpWidget(MyApp(apiClient: fakeApiClient()));
    await tester.tap(find.text('Add Skill'));
    await tester.pumpAndSettle();

    await tester.enterText(nameField(), 'Dart');
    await tester.pump();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Discard changes?'), findsOneWidget);

    await tester.tap(find.text('Keep Editing'));
    await tester.pumpAndSettle();
    expect(find.text('Add Skill Form'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.text('Add Skill Form'), findsNothing);
  });

  testWidgets('home cards open the skill pages and a skill can be deleted', (
    tester,
  ) async {
    await useTallScreen(tester);
    await tester.pumpWidget(MyApp(apiClient: fakeApiClient()));

    await tester.tap(find.text('View Skills'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No skills added yet'), findsOneWidget);

    await tester.tap(find.text('Add Skill'));
    await tester.pumpAndSettle();
    await tester.enterText(nameField(), 'Flutter');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View List'));
    await tester.pumpAndSettle();

    expect(find.text('Skills'), findsWidgets);
    expect(find.text('Flutter'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    expect(skillStore.items, isEmpty);
    expect(find.textContaining('No skills added yet'), findsOneWidget);
  });
}
