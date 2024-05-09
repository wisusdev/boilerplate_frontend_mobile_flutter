import 'package:flutter_dotenv/flutter_dotenv.dart';

final String api_url = dotenv.get('API_URL');
final String api_version = dotenv.get('API_VERSION');

final api_url_v1 = '$api_url/$api_version';