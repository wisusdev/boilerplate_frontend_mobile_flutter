import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';

class LocationDelegate extends LocalizationsDelegate<Location> {
	const LocationDelegate();

  	@override
  	bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  	@override
  	Future<Location> load(Locale locale) async {
		Location localizations = Location(locale);
		await localizations.load();
		return localizations;
  	}

  	@override
  	bool shouldReload(LocationDelegate old) => false;
}