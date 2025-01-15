import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/home.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/account/profile_main.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/settings/setting_main.dart';

class AppLayout extends StatefulWidget {
    const AppLayout({super.key});

    @override
    State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {

    int currentIndex = 0;

    callPage(int currentIndex) {
        switch (currentIndex) {
            case 0:
                return const HomeView();
            case 1:
                return const ProfileMain();
            case 2:
                return const SettingMain();
            default:
                return const HomeView();
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