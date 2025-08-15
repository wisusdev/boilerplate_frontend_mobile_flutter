import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/utils/menu.dart';

class DrawerMenuLeft extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DrawerMenuLeft({super.key, required this.scaffoldKey});

  @override
  State<DrawerMenuLeft> createState() => _DrawerMenuLeftState();
}

class _DrawerMenuLeftState extends State<DrawerMenuLeft> {
  int _selectedIndex = -1; // -1 indica que ningún elemento del drawer está seleccionado por defecto

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: _selectedIndex,

      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
        final menuItem = appMenuItems[index];
        Navigator.of(context).pushNamed(menuItem.link);
        widget.scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        NavigationDrawerDestination(
          icon: Icon(appMenuItems[0].icon),
          label: Text(capitalizeText(Location.of(context)!.trans(appMenuItems[0].title))),
        ),
        NavigationDrawerDestination(
          icon: Icon(appMenuItems[1].icon),
          label: Text(capitalizeText(Location.of(context)!.trans(appMenuItems[1].title))),
        ),
        NavigationDrawerDestination(
          icon: Icon(appMenuItems[2].icon),
          label: Text(capitalizeText(Location.of(context)!.trans(appMenuItems[2].title))),
        ),
      ],
    );
  }
}
