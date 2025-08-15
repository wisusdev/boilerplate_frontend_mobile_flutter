import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/interfaces/local/menu_model.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/home_index.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/account/profile_index.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/settings/setting_index.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/permissions/permission_index.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/roles/role_index.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/base/users/user_index.dart';

const appMenuItems = <MenuItem>[
    // Bottom Navigation Items
    MenuItem(
        title: 'home',
        subTitle: 'Home view', 
        link: 'home', 
        icon: Icons.home,
        location: MenuLocation.bottomNavigation,
        page: HomeIndex(),
        order: 1,
    ),
    MenuItem(
        title: 'profile',
        subTitle: 'Profile view', 
        link: 'profile', 
        icon: Icons.person,
        location: MenuLocation.bottomNavigation,
        page: ProfileIndex(),
        order: 2,
    ),
    MenuItem(
        title: 'settings',
        subTitle: 'Settings view', 
        link: 'settings', 
        icon: Icons.settings,
        location: MenuLocation.bottomNavigation,
        page: SettingIndex(),
        order: 3,
    ),

    // Drawer Items
    MenuItem(
        title: 'permissions', 
        subTitle: 'Permissions view', 
        link: 'permissions_index', 
        icon: Icons.lock,
        location: MenuLocation.drawer,
        page: PermissionIndex(),
        order: 1,
    ),
    MenuItem(
        title: 'roles', 
        subTitle: 'Roles view', 
        link: 'roles_index', 
        icon: Icons.assignment_ind,
        location: MenuLocation.drawer,
        page: RoleIndex(),
        order: 2,
    ),
    MenuItem(
        title: 'users', 
        subTitle: 'Users view', 
        link: 'users_index', 
        icon: Icons.supervised_user_circle,
        location: MenuLocation.drawer,
        page: UserIndex(),
        order: 3,
    ),
];

// Helper functions para obtener elementos por ubicación
List<MenuItem> getBottomNavigationItems() {
  return appMenuItems.where((item) => item.location == MenuLocation.bottomNavigation).toList()..sort((a, b) => a.order.compareTo(b.order));
}

List<MenuItem> getDrawerItems() {
  return appMenuItems.where((item) => item.location == MenuLocation.drawer).toList()..sort((a, b) => a.order.compareTo(b.order));
}

// Helper function para obtener todos los elementos ordenados
List<MenuItem> getAllMenuItems() {
  final bottomNavItems = getBottomNavigationItems();
  final drawerItems = getDrawerItems();
  return [...bottomNavItems, ...drawerItems];
}