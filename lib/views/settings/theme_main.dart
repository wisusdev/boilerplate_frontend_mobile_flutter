import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/helpers/text.dart';
import 'package:todolist_flutter/app/providers/theme_provider.dart';
import 'package:todolist_flutter/app/preferences/theme_preferences.dart';


class ThemeMain extends StatefulWidget {
  	const ThemeMain({super.key});

  	@override
  	State<ThemeMain> createState() => _ThemeMainState();
}

class _ThemeMainState extends State<ThemeMain> {
  	@override
  	Widget build(BuildContext context) {

        final themeMode = Provider.of<ThemeProvider>(context).themeMode;

		return Scaffold(
            appBar: AppBar(
                title: Text(
                    capitalizeText(Location.of(context)!.trans('theme')),
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
                        
                        Text('Provider: ${ Provider.of<ThemeProvider>(context).themeMode }'),
                        Text('ThemePreferences: ${ ThemePreferences.getThemeMode() }'),
                        const Divider(),

                        Card(
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 2),
                                borderRadius: BorderRadius.circular(20),
                            ),
                            child: RadioListTile(
                                title: Text(capitalizeText(Location.of(context)!.trans('light_theme'))), 
                                value: ThemeMode.light,
                                selected: themeMode == ThemeMode.light,
                                groupValue: themeMode,
                                onChanged: (value){
                                    Provider.of<ThemeProvider>(context, listen: false).setThemeMode(value!);
                                    ThemePreferences.setThemeMode(value);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                            ),
                        ),

                        Card(
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 2),
                                borderRadius: BorderRadius.circular(20),
                            ),
                            child: RadioListTile(
                                title: Text(capitalizeText(Location.of(context)!.trans('dark_theme'))),
                                value: ThemeMode.dark,
                                selected: themeMode == ThemeMode.dark,
                                groupValue: themeMode,
                                onChanged: (value){
                                    Provider.of<ThemeProvider>(context, listen: false).setThemeMode(value!);
                                    ThemePreferences.setThemeMode(value);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                            ),
                        ),

                        Card(
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 2),
                                borderRadius: BorderRadius.circular(20),
                            ),
                            child: RadioListTile(
                                title: Text(capitalizeText(Location.of(context)!.trans('system_theme'))),
                                value: ThemeMode.system, 
                                selected: themeMode == ThemeMode.system,
                                groupValue: themeMode,
                                onChanged: (value){
                                    Provider.of<ThemeProvider>(context, listen: false).setThemeMode(value!);
                                    ThemePreferences.setThemeMode(value);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
  	}
}