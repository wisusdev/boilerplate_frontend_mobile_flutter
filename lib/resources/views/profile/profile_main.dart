import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/helpers/text.dart';
import 'package:todolist_flutter/config/app.dart';

class ProfileMain extends StatefulWidget {
    const ProfileMain({Key? key}) : super(key: key);

    @override
    State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            
            appBar: AppBar(
                leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
                title: Text(
                    capitalizeText(Location.of(context)!.trans('profile')), 
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary
                    )
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            
            body: Center(
                child: Text(appName),
            ),

            floatingActionButton: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.qr_code_scanner, color: Theme.of(context).colorScheme.onPrimary),
            )
        );
    }
}