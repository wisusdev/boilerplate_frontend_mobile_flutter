import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/layouts/app_layout.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/preferences/theme_preferences.dart';

class HomeView extends StatefulWidget {
  static const String title = 'home';

  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "home",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('isDarkmode: ${ThemePreferences.getThemeMode()}'),
          const Divider(),
        ],
      ),
    );
  }
}
