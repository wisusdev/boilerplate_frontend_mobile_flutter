import 'package:flutter_dotenv/flutter_dotenv.dart';

final Map<String, String> todoListService = {
    'url': dotenv.get('API_URL'),
    'api_version': dotenv.get('API_VERSION'),
};