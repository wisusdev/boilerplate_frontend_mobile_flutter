import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:boilerplate_frontend_mobile_flutter/config/app.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/languages.dart';
import 'package:boilerplate_frontend_mobile_flutter/routes/api_routes.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/http/guards/auth_guard.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/local_storage.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/layouts/app_layout.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/preferences/language_preferences.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/preferences/theme_preferences.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/providers/language_provider.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/providers/theme_provider.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/location_delegate.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/themes/dark_theme.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/themes/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorage.init();

  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider(themeMode: ThemePreferences.getThemeMode())),
      ChangeNotifierProvider(create: (context) => LanguageProvider(languageLocale: Locale(LanguagePreferences.getLanguageMode()))),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,

      debugShowCheckedModeBanner: true,

      supportedLocales: supportedLocales,
      locale: Provider.of<LanguageProvider>(context).language,

      localizationsDelegates: const [
        LocationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: Provider.of<ThemeProvider>(context).themeMode,

      home: const AuthGuard(child: AppLayout()),
      routes: api,
    );
  }
}
