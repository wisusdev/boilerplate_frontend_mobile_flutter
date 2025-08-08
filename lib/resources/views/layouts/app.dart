import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/drawer_menu_left.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/home.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/guards/auth_guard.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/account/profile_main.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/settings/setting_main.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic> callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return {
          'title': HomeView.title,
          'widget': const AuthGuard(child: HomeView())
        };
      case 1:
        return {
          'title': ProfileMain.title,
          'widget': const AuthGuard(child: ProfileMain())
        };
      case 2:
        return {
          'title': SettingMain.title,
          'widget': const AuthGuard(child: SettingMain())
        };
      default:
        return {
          'title': HomeView.title,
          'widget': const AuthGuard(child: HomeView())
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = callPage(currentIndex);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(capitalizeText(Location.of(context)!.trans(page['title'])),
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),

      body: page['widget'],

      drawer: DrawerMenuLeft(scaffoldKey: _scaffoldKey),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: capitalizeText(Location.of(context)!.trans('home')),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: capitalizeText(Location.of(context)!.trans('profile')),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: capitalizeText(Location.of(context)!.trans('settings')),
          ),
        ],
      ),
    );
  }
}