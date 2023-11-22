import 'package:flutter_dotenv/flutter_dotenv.dart';

class App {

    static String get appName {
        return dotenv.get('APP_NAME');
    }

    static String get appVersion {
        return dotenv.get('APP_VERSION');
    }

    static String get appLanguage {
        return dotenv.get('APP_LANGUAGE');
    }

}