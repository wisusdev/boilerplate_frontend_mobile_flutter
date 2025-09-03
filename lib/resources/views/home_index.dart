import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/preferences/theme_preferences.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({Key? key}) : super(key: key);

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('isDarkmode: ${ThemePreferences.getThemeMode()}'),
        const Divider(),
      ],
    );
  }
}
