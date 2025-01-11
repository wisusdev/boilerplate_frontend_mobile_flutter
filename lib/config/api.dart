import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = Platform.isAndroid && dotenv.env['APP_ENV'] == 'local' ? 'http://10.0.2.2:8000/api' : dotenv.env['APP_BACKEND_URL']!;
const String apiVersion = 'v1';
final String apiUrlV1 = '$apiUrl/$apiVersion';
