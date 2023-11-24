import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';
import 'package:todolist_flutter/app/preferences/theme_preferences.dart';
import 'package:todolist_flutter/config/app.dart';
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
                ChangeNotifierProvider(create: (context) => ThemeProvider(themeMode: ThemePreferences.getThemeMode())),
            ], 
            child: const MyApp()
        ),
    );
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

  	@override
  	Widget build(BuildContext context) {
	
		return MaterialApp(
		  	// Titulo de la app
			title: 'Flutter Demo',
	
			// Desactivar el banner de debug
			debugShowCheckedModeBanner: false,
	
			// Soporte para idiomas
			locale: Locale(appLang, appLangCountry),
	
		  	supportedLocales: const [
				Locale('en', 'US'),
				Locale('es', 'ES'),
		  	],
		
			localizationsDelegates: const [
				LocationDelegate(),
				GlobalMaterialLocalizations.delegate,
				GlobalWidgetsLocalizations.delegate,
				GlobalCupertinoLocalizations.delegate,
			],
	
			localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
				if (locale != null) {
					for (var supportedLocale in supportedLocales) {
						if (supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode) {
							return supportedLocale;
						}
					}
				}
	
				return supportedLocales.first;
			},
	
			// Soporte para temas
			theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
			darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
			themeMode: Provider.of<ThemeProvider>(context).themeMode,
	
			// Rutas
		  	home: const HomeView(),
			routes: {
				'home': (context) => const HomeView(),
				'profile': (context) => const ProfileMain(),
				'setting': (context) => const SettingMain(),
	
				// settings
				'language': (context) => const LanguajeMain(),
				'theme': (context) => const ThemeMain(),
			},
	
		);
  	}
}
