import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/drawer_menu_left.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/utils/menu.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/navigation_helper.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onDrawerItemSelected(int drawerIndex) {
    setState(() {
      _selectedIndex = AppNavigationHelper.drawerToGlobalIndex(drawerIndex);
    });
    _scaffoldKey.currentState?.closeDrawer();
  }

  void _onBottomNavItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Inicializar en home
    _selectedIndex = AppNavigationHelper.getGlobalIndex('home');
    if (_selectedIndex == -1) _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentMenuItem = AppNavigationHelper.getMenuItemByGlobalIndex(_selectedIndex);

    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        title: Text(capitalizeText(Location.of(context)!.trans(currentMenuItem?.title ?? 'home')), style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),

      body: currentMenuItem?.page ?? Container(),

      drawer: DrawerMenuLeft(
        scaffoldKey: _scaffoldKey,
        onItemSelected: _onDrawerItemSelected,
        selectedIndex: AppNavigationHelper.isDrawerIndex(_selectedIndex) ? AppNavigationHelper.globalToDrawerIndex(_selectedIndex) : -1,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: AppNavigationHelper.isBottomNavigationIndex(_selectedIndex) ? _selectedIndex : 0,
        onTap: _onBottomNavItemSelected,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppNavigationHelper.isBottomNavigationIndex(_selectedIndex) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        items: getBottomNavigationItems()
            .map((menuItem) => BottomNavigationBarItem(
                  icon: Icon(menuItem.icon),
                  label: capitalizeText(Location.of(context)!.trans(menuItem.title)),
                ))
            .toList(),
      ),
    );
  }
}
