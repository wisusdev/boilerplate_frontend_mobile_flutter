import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/utils/menu.dart';

class DrawerMenuLeft extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final void Function(int)? onItemSelected;
  final int selectedIndex;

  const DrawerMenuLeft({
    super.key, 
    required this.scaffoldKey,
    this.onItemSelected,
    this.selectedIndex = -1,
  });

  @override
  State<DrawerMenuLeft> createState() => _DrawerMenuLeftState();
}

class _DrawerMenuLeftState extends State<DrawerMenuLeft> {

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: widget.selectedIndex, // Usar el índice externo

      onDestinationSelected: (index) {
        if (widget.onItemSelected != null) {
          // Si hay callback, usar el nuevo sistema
          widget.onItemSelected!(index);
        } else {
          // Mantener comportamiento anterior para compatibilidad
          final drawerItems = getDrawerItems();
          final menuItem = drawerItems[index];
          Navigator.of(context).pushNamed(menuItem.link);
          widget.scaffoldKey.currentState?.closeDrawer();
        }
      },
      children: getDrawerItems()
          .map((menuItem) => NavigationDrawerDestination(
                icon: Icon(menuItem.icon),
                label: Text(capitalizeText(Location.of(context)!.trans(menuItem.title))),
              ))
          .toList(),
    );
  }
}
