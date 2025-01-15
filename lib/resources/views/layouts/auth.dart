import 'package:boilerplate_frontend_mobile_flutter/resources/views/settings/setting_main.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatefulWidget {
    const AuthLayout({super.key});

    @override
    State<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> {

    int currentIndex = 0;

    callPage(int currentIndex) {
        switch (currentIndex) {
            case 0:
                return const SettingMain();
            default:
                return const SettingMain();
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: callPage(currentIndex),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (int index) {
                    setState(() {
                        currentIndex = index;
                    });
                },
                items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Settings',
                    ),
                ],
            ),
        );
    }
}