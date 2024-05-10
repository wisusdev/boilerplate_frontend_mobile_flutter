import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.get('API_URL');
final String apiVersion = dotenv.get('API_VERSION');

final String apiUrlV1 = '$apiUrl/$apiVersion';
