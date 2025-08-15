import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/drawer_menu_left.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/home.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/account/profile_main.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/settings/setting_main.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final String title;

  const AppLayout({super.key, required this.child, required this.title});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const HomeView(),
    const ProfileMain(),
    const SettingMain(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        title: Text(capitalizeText(Location.of(context)!.trans(widget.title)), style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),

      body: widget.child,

      drawer: DrawerMenuLeft(scaffoldKey: _scaffoldKey),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: capitalizeText(Location.of(context)!.trans('home')),),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: capitalizeText(Location.of(context)!.trans('profile')),),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: capitalizeText(Location.of(context)!.trans('settings')),),
        ],
      ),
    );
  }
}
