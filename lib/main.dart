import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';
import 'package:todolist_flutter/app/preferences/language_preferences.dart';
import 'package:todolist_flutter/app/preferences/theme_preferences.dart';
import 'package:todolist_flutter/app/providers/language_provider.dart';
import 'package:todolist_flutter/config/languages.dart';
import 'package:todolist_flutter/views/auth/forgot_password.dart';
import 'package:todolist_flutter/views/auth/login.dart';
import 'package:todolist_flutter/views/auth/register.dart';
import 'package:todolist_flutter/views/home.dart';
import 'package:todolist_flutter/config/themes.dart';
import 'package:todolist_flutter/views/settings/theme_main.dart';
import 'package:todolist_flutter/app/helpers/local_storage.dart';
import 'package:todolist_flutter/views/profile/profile_main.dart';
import 'package:todolist_flutter/views/settings/setting_main.dart';
import 'package:todolist_flutter/app/providers/theme_provider.dart';
import 'package:todolist_flutter/views/settings/language_main.dart';
import 'package:todolist_flutter/app/helpers/location_delegate.dart';


void main() async {
	await dotenv.load(fileName: '.env');
    await LocalStorage.init();

  	runApp(
        MultiProvider(
            providers: [
                ChangeNotifierProvider(create: (context) => ThemeProvider(
                    themeMode: ThemePreferences.getThemeMode()
                )),
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
                        title: 'Flutter Demo',

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
                        home: const AuthLogin(),
                        routes: {
                            'home': (context) => const HomeView(),
                            'profile': (context) => const ProfileMain(),
                            'setting': (context) => const SettingMain(),

                            // Auth
                            'login': (context) => const AuthLogin(),
                            'register': (context) => const AuthRegister(),
                            'forgot_password': (context) => const AuthForgotPassword(),
                
                            // settings
                            'language': (context) => const LanguajeMain(),
                            'theme': (context) => const ThemeMain(),
                        },
                    );
                },
            )
        );
  	}
}
