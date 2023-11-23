import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/helpers/text.dart';
import 'package:todolist_flutter/config/app.dart';

class SettingMain extends StatefulWidget {
    const SettingMain({Key? key}) : super(key: key);

    @override
    State<SettingMain> createState() => _SettingMainState();
}

class _SettingMainState extends State<SettingMain> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            
            appBar: AppBar(
                title: Text(
                    capitalizeText(Location.of(context)!.trans('settings')),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary
                    )
                ),
                iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
                backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            
            body: Center(
                child: Text(appName),
            )
        );
    }
}