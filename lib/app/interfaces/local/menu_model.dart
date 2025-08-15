import 'package:flutter/material.dart';

enum MenuLocation {
  bottomNavigation,
  drawer,
}

class MenuItem {
    final String title;
    final String subTitle;
    final String link;
    final IconData icon;
    final MenuLocation location;
    final Widget? page; // Para navegación interna
    final int order; // Para ordenar elementos

    const MenuItem({
        required this.title,
        required this.subTitle,
        required this.link,
        required this.icon,
        required this.location,
        this.page,
        this.order = 0,
    });
}