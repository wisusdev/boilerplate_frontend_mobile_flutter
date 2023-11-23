import 'package:flutter_dotenv/flutter_dotenv.dart';

// Titulo de la app
final appName = dotenv.get('APP_NAME');

// Version de la app
final appVersion = dotenv.get('APP_VERSION');

// Soporte para idiomas
final appLang = dotenv.get('APP_LANG');
final appLangCountry = dotenv.get('APP_LANG_COUNTRY');