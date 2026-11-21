import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/state/education_store.dart';
import 'package:myportofolio_mobile/widgets/date_field.dart';

/// Pumps the form on a tall surface so every field is on screen.
Future<void> pumpForm(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));
}

Future<void> pickDate(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(DateField, label));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(educationStore.clear);

  testWidgets('Save with empty input shows an error next to each field', (
    tester,
  ) async {
    await pumpForm(tester);

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Institution is required.'), findsOneWidget);
    expect(find.text('Major is required.'), findsOneWidget);
    expect(find.text('Pick the start date.'), findsOneWidget);
    expect(find.text('Pick the end date.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    expect(educationStore.items, isEmpty);
  });

  testWidgets('whitespace-only input is rejected', (tester) async {
    await pumpForm(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Institution'),
      '   ',
    );
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Institution is required.'), findsOneWidget);
  });

  testWidgets('invalid GPA is rejected', (tester) async {
    await pumpForm(tester);

    await tester.enterText(find.widgetWithText(TextFormField, 'GPA'), '4.5');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('GPA must be between 0.00 and 4.00.'), findsOneWidget);
  });

  testWidgets('valid input shows the summary dialog and resets the form', (
    tester,
  ) async {
    await pumpForm(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Institution'),
      'Universitas Indonesia',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Major'),
      'Computer Science',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'GPA'), '3.75');
    await pickDate(tester, 'Start Date');
    await pickDate(tester, 'End Date');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Education added successfully!'), findsOneWidget);
    expect(find.text('Institution: Universitas Indonesia'), findsOneWidget);
    expect(find.text('Major: Computer Science'), findsOneWidget);
    expect(find.text('GPA: 3.75'), findsOneWidget);
    expect(educationStore.items, hasLength(1));

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Universitas Indonesia'), findsNothing);
  });

  testWidgets('"Still studying here" removes the end date requirement', (
    tester,
  ) async {
    await pumpForm(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Institution'),
      'SMA Negeri 1',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'Major'), 'IPA');
    await pickDate(tester, 'Start Date');
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Education added successfully!'), findsOneWidget);
    expect(find.textContaining('Present'), findsOneWidget);
    expect(educationStore.items.single.isOngoing, isTrue);
  });

  testWidgets('leaving with unsaved input asks for confirmation', (
    tester,
  ) async {
    await pumpForm(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Institution'),
      'UI',
    );
    await tester.pump();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Discard changes?'), findsOneWidget);

    await tester.tap(find.text('Keep Editing'));
    await tester.pumpAndSettle();
    expect(find.text('Discard changes?'), findsNothing);
    expect(find.byType(EducationFormPage), findsOneWidget);
  });

  testWidgets('home card and drawer open the education pages', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());

    // Action card -> form (push), system back -> home.
    await tester.tap(find.text('Add Education'));
    await tester.pumpAndSettle();
    expect(find.text('Add Education Form'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);

    // Drawer -> form, then drawer -> Home.
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Add Education'));
    await tester.pumpAndSettle();
    expect(find.text('Add Education Form'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Home'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to MyPortfolio Mobile!'), findsOneWidget);
  });
}
