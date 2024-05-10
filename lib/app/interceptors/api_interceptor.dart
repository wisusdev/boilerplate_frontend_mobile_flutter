import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiInterceptor extends http.BaseClient {

  final http.Client _inner = http.Client();
  final storage = const FlutterSecureStorage();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {

    String? token = await storage.read(key: 'token');

    if (request is http.Request) {
      if (request.method == 'POST' || request.method == 'PATCH' || request.method == 'PUT') {

        var body = json.decode(request.body);
        var type = body['type'];
        body.remove('type');

        var data = {
          'type': type,
          'attributes': body,
        };

        if (request.method == 'PATCH' || request.method == 'PUT') {
          data['id'] = body['id'];
        }
        request.body = json.encode({'data': data});
      }
    }

    request.headers['content-type'] = 'application/vnd.api+json';
    request.headers['accept'] = 'application/vnd.api+json';
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    return _inner.send(request);
  }
}
