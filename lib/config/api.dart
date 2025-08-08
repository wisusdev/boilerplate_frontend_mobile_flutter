import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrlV1 = getApiUrl();

String getApiUrl() {
  final String apiUrl = dotenv.env['APP_BACKEND_URL']!;
  final String apiVersion = dotenv.env['APP_API_VERSION'] ?? 'v1';
  final String env = dotenv.env['APP_ENV'] ?? 'local';
  final bool isLocal = env == 'local';

  if (apiVersion.isEmpty) {
    return '$apiUrl/api/$apiVersion';
  }

  if (isLocal) {
    String localHost;
    if (defaultTargetPlatform == TargetPlatform.android) {
      localHost = '10.0.2.2:8000';
    } else {
      localHost = 'localhost:8000';
    }
    return 'http://$localHost/api/$apiVersion';
  }

  return '$apiUrl/$apiVersion';
}