import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todolist_flutter/app/helpers/location_delegate.dart';
import 'package:todolist_flutter/views/profile.dart';

void main() async {
	await dotenv.load(fileName: '.env');
  	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

  	@override
  	Widget build(BuildContext context) {
		return MaterialApp(
	  		title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,

            locale: const Locale('es', 'ES'),

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

	  		theme: ThemeData(
				colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
				useMaterial3: true,
	  		),

	  		home: const ProfileView(),
		);
  	}
}
