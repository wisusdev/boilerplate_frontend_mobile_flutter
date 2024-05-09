import 'package:flutter_dotenv/flutter_dotenv.dart';

// Titulo de la app
final appName = dotenv.get('APP_NAME');

// Version de la app
final appVersion = dotenv.get('APP_VERSION');

// Soporte para idiomas
final appLang = dotenv.get('APP_LANG');
final appLangName = dotenv.get('APP_LANG_NAME');
final appLangCountry = dotenv.get('APP_LANG_COUNTRY');

const logoApp = 'lib/assets/images/wisus-logo.png';