import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/preferences/language_preferences.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/providers/language_provider.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/utils/languages.dart';

class LanguajeMain extends StatefulWidget {
  	const LanguajeMain({super.key});

  	@override
  	State<LanguajeMain> createState() => _LanguajeMainState();
}

class _LanguajeMainState extends State<LanguajeMain> {
  	@override
  	Widget build(BuildContext context) {
        
        final languageMode = Provider.of<LanguageProvider>(context).language;

		return Scaffold(
            appBar: AppBar(
                title: Text(
                    capitalizeText(Location.of(context)!.trans('language')),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary
                    )
                ),
                iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
                backgroundColor: Theme.of(context).colorScheme.primary,
            ),

            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        for(var language in languages)
                            Card(
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                ),
                                child: RadioListTile(
                                    title: Text(language.languageName),
                                    value: Locale(language.languageCode),
                                    selected: languageMode == Locale(language.languageCode),
                                    groupValue: languageMode,
                                    onChanged: (value){
                                        Provider.of<LanguageProvider>(context, listen: false).setLanguage(value!);
                                        LanguagePreferences.setLanguageMode(value);
                                    },
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(width: 2),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                )
                            ),                        
                    ],
                ),
            )
        );
  	}
}