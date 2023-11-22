import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/config/app.dart';

class ProfileView extends StatefulWidget {
    const ProfileView({Key? key}) : super(key: key);

    @override
    State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(Location.of(context)!.trans('profile')),
            ),
            body: Center(
                child: Text(App.appName),
            ),
        );
    }
}