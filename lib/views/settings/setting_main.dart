import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/helpers/text.dart';

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
            
            body: SafeArea(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: ListView(
                        children: [
                            ListTile(
                                leading: const Icon(Icons.translate),
                                title: Text(capitalizeText(Location.of(context)!.trans('language'))),
                                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                onTap: () {
                                    Navigator.of(context).pushNamed('language');
                                },
                            ),

                            ListTile(
                                leading: const Icon(Icons.palette),
                                title: Text(capitalizeText(Location.of(context)!.trans('theme'))),
                                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                onTap: () {
                                    Navigator.of(context).pushNamed('theme');
                                },
                            ),
                        ],
                    ),
                )
            )
        );
    }
}