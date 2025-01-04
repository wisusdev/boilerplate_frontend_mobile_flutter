import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/drawer_menu_left.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/preferences/theme_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
    @override
    Widget build(BuildContext context) {

        final scaffoldKey = GlobalKey<ScaffoldState>();

        return Scaffold(
            key: scaffoldKey,
            
            appBar: AppBar(
                title: Text(
                    capitalizeText(Location.of(context)!.trans('home')),
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)
                ),
                iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
                backgroundColor: Theme.of(context).colorScheme.primary,
            ),

            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text('isDarkmode: ${ ThemePreferences.getThemeMode() }'),
                    const Divider(),
                ],
            ),

            floatingActionButton: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.qr_code_scanner, color: Theme.of(context).colorScheme.onPrimary),
            ),

            drawer: DrawerMenuLeft(scaffoldKey : scaffoldKey),
        );
  }
}