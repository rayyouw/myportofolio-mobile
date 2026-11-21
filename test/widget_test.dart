import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Home page shows info cards and shows SnackBar on tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Rayhan Fairuz Aqram'), findsOneWidget);
    expect(find.text('2506586186'), findsOneWidget);
    expect(find.text('PBP D'), findsOneWidget);
    expect(find.text('View Projects'), findsOneWidget);

    await tester.tap(find.text('View Projects'));
    await tester.pump();

    expect(find.text('You pressed the View Projects button!'), findsOneWidget);
  });

  testWidgets('Add Project card opens the project form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsOneWidget);
  });
}
