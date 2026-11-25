import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

import 'helpers/fake_api.dart';

void main() {
  group('Project', () {
    test('fromJson maps snake_case keys and defaults missing image URL', () {
      final project = Project.fromJson({
        'id': 7,
        'title': 'App',
        'description': 'Desc',
        'tech_stack': 'Flutter',
        'project_url': 'https://example.com',
        'project_image_url': null,
      });

      expect(project.id, 7);
      expect(project.techStack, 'Flutter');
      expect(project.projectUrl, 'https://example.com');
      expect(project.projectImageUrl, '');
    });

    test('toJson omits the server-assigned id', () {
      const project = Project(
        id: 3,
        title: 'App',
        description: 'Desc',
        techStack: 'Flutter',
        projectUrl: 'https://example.com',
      );

      final json = project.toJson();
      expect(json.containsKey('id'), isFalse);
      expect(json['tech_stack'], 'Flutter');
      expect(json['project_image_url'], '');
    });
  });

  group('ApiClient', () {
    test('getProjects decodes the project list', () async {
      final projects = await fakeApiClient().getProjects();
      expect(projects, hasLength(1));
      expect(projects.first.title, 'MyPortfolio');
    });

    test('createProject sends the token header and JSON body', () async {
      final requests = <http.Request>[];
      final api = fakeApiClient(requests: requests);

      final created = await api.createProject(
        const Project(
          title: 'New',
          description: 'Desc',
          techStack: 'Dart',
          projectUrl: 'https://example.com',
        ),
        token: 'test-token',
      );

      expect(created.id, 99);
      final request = requests.single;
      expect(request.headers['Authorization'], 'Token test-token');
      expect(jsonDecode(request.body)['title'], 'New');
    });

    test('non-2xx responses throw ApiException', () async {
      final api = fakeApiClient();
      expect(
        () => api.createProject(
          const Project(
            title: 'New',
            description: 'Desc',
            techStack: 'Dart',
            projectUrl: 'https://example.com',
          ),
          token: 'bad',
        ),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });
  });

  group('AuthState', () {
    test('login stores the token and logout clears it', () async {
      final auth = AuthState(fakeApiClient());
      expect(auth.isLoggedIn, isFalse);

      await auth.login('me', 'secret');
      expect(auth.token, 'test-token');

      await auth.logout();
      expect(auth.isLoggedIn, isFalse);
    });

    test('logout clears the token even when the server fails', () async {
      final api = ApiClient(
        client: MockClient((_) async => http.Response('', 401)),
        baseUrl: 'http://test',
      );
      final auth = AuthState(api, initialToken: 'expired');

      await auth.logout();
      expect(auth.isLoggedIn, isFalse);
    });
  });
}
