import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/main.dart';

import 'helpers/fake_api.dart';

void main() {
  testWidgets('Home page shows info cards and shows SnackBar on tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApiClient()));

    expect(find.text('Rayhan Fairuz Aqram'), findsOneWidget);
    expect(find.text('2506586186'), findsOneWidget);
    expect(find.text('PBP D'), findsOneWidget);
    expect(find.text('View Projects'), findsOneWidget);

    await tester.tap(find.text('View Projects'));
    await tester.pump();

    expect(find.text('You pressed the View Projects button!'), findsOneWidget);
  });

  testWidgets('View Projects card lists projects from the API', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApiClient()));

    await tester.tap(find.text('View Projects'));
    await tester.pumpAndSettle();

    expect(find.text('Achievements: Projects'), findsOneWidget);
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Django, Tailwind'), findsOneWidget);

    await tester.tap(find.text('MyPortfolio'));
    await tester.pumpAndSettle();
    expect(find.text('https://github.com/example/myportfolio'), findsOneWidget);
    expect(find.text('Project Image URL'), findsNothing);
  });

  testWidgets('empty project list shows a message', (tester) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApiClient(projects: [])));

    await tester.tap(find.text('View Projects'));
    await tester.pumpAndSettle();

    expect(find.text('No projects found.'), findsOneWidget);
  });

  testWidgets('Add Project asks for a login before opening the form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApiClient()));

    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsNothing);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'me',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'secret',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsOneWidget);
  });

  testWidgets('wrong password keeps the user on the login screen', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: fakeApiClient()));

    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'me',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'wrong',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Login failed (400)'), findsOneWidget);
    expect(find.text('Add Project Form'), findsNothing);
  });

  testWidgets('logged-in user can POST a new project', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final requests = <http.Request>[];
    await tester.pumpWidget(
      MyApp(apiClient: fakeApiClient(requests: requests)),
    );

    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'me',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'secret',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Title'), 'App');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description'),
      'Mobile app',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Tech Stack'),
      'Flutter',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Project URL'),
      'https://example.com/app',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Project added successfully!'), findsOneWidget);
    final post = requests.lastWhere((r) => r.method == 'POST');
    expect(post.url.path, '/api/v1/projects/');
    expect(post.headers['Authorization'], 'Token test-token');
  });
}
