import 'package:flutter/material.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('isDarkmode: ${ThemePreferences.getThemeMode()}'),
        const Divider(),
      ],
    );
  }
}
