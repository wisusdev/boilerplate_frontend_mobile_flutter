import 'package:flutter_dotenv/flutter_dotenv.dart';

// Titulo de la app
final appName = dotenv.env['APP_NAME'] ?? 'Placeholder';

// Version de la app
final appVersion = dotenv.env['APP_VERSION'] ?? '1.0.0';

// Soporte para idiomas
final appLang = dotenv.env['APP_LANG'] ?? 'es';

const logoApp = 'lib/assets/images/wisus-logo.png';
const profileImageDefault = 'lib/assets/images/profile.png';

const allowImageTypes = ['image/jpg', 'image/jpeg', 'image/png'];
const allowImageSize = 1024 * 1024 * 2; // 2MB