import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:provider/provider.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/guards/auth_guard.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/preferences/language_preferences.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/preferences/theme_preferences.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/providers/auth_provider.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/providers/language_provider.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/auth_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/app.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/languages.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/local_storage.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/providers/theme_provider.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location_delegate.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/themes/dark_theme.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/themes/light_theme.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/home.dart';
import 'package:boilerplate_frontend_mobile_flutter/routes/router.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await LocalStorage.init();

    await dotenv.load(fileName: ".env");

  	runApp(
        MultiProvider(
            providers: [
                ChangeNotifierProvider(create: (context) => ThemeProvider(themeMode: ThemePreferences.getThemeMode())),
                ChangeNotifierProvider(create: (context) => AuthService()),
                ChangeNotifierProvider(create: (context) => AuthProvider()),
            ], 
            child: const MyApp()
        ),
    );
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

  	@override
  	Widget build(BuildContext context) {
        return ChangeNotifierProvider(
            create: (context) => LanguageProvider(languageLocale: Locale(LanguagePreferences.getLanguageMode())),
            child: Consumer<LanguageProvider>(
                builder: (context, languageProvider, child) {
                    return MaterialApp(
                        // Titulo de la app
						title: appName,

                        // Desactivar el banner de debug
                        debugShowCheckedModeBanner: false,

                        // Soporte para idiomas
                        supportedLocales: supportedLocales,
                        locale: languageProvider.language,
                    
                        localizationsDelegates: const [
                            LocationDelegate(),
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                            GlobalCupertinoLocalizations.delegate,
                        ],

                        // Soporte para temas
                        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
                        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
                        themeMode: Provider.of<ThemeProvider>(context).themeMode,

                        // Rutas
                        home: const AuthGuard(child: HomeView()),
                        routes: routes,
                    );
                },
            )
        );
  	}
}
