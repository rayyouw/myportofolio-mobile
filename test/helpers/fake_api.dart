import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

/// Sample project payload in the shape returned by the Django API.
const sampleProjectJson = <String, dynamic>{
  'id': 1,
  'title': 'MyPortfolio',
  'description': 'Personal portfolio built with Django.',
  'tech_stack': 'Django, Tailwind',
  'project_url': 'https://github.com/example/myportfolio',
  'project_image_url': '',
};

/// Builds an [ApiClient] backed by an in-memory fake of the Django backend.
///
/// Every request is appended to [requests] so tests can inspect it.
ApiClient fakeApiClient({
  List<Map<String, dynamic>> projects = const [sampleProjectJson],
  String validPassword = 'secret',
  List<http.Request>? requests,
}) {
  final client = MockClient((request) async {
    requests?.add(request);
    final path = request.url.path;

    if (path == '/api/v1/projects/' && request.method == 'GET') {
      return http.Response(jsonEncode(projects), 200);
    }
    if (path == '/api/v1/projects/' && request.method == 'POST') {
      if (request.headers['Authorization'] != 'Token test-token') {
        return http.Response('{"detail":"Invalid token."}', 401);
      }
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(jsonEncode({...body, 'id': 99}), 201);
    }
    if (path == '/api/v1/auth/token/') {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      if (body['password'] == validPassword) {
        return http.Response('{"token":"test-token"}', 200);
      }
      return http.Response('{"non_field_errors":["Bad credentials"]}', 400);
    }
    if (path == '/api/v1/auth/logout/') {
      return http.Response('', 204);
    }
    return http.Response('Not found', 404);
  });
  return ApiClient(client: client, baseUrl: 'http://test');
}
