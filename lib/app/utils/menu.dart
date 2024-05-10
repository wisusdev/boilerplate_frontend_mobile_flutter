import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/models/menu_model.dart';


const appMenuItems = <MenuItem>[
    MenuItem(
		title: 'home', 
		subTitle: 'Home view', 
		link: 'home', 
		icon: Icons.home
	),

	MenuItem(
		title: 'profile', 
		subTitle: 'Profile view', 
		link: 'profile', 
		icon: Icons.person
	),

	MenuItem(
		title: 'settings', 
		subTitle: 'Settings app', 
		link: 'setting', 
		icon: Icons.settings
	),

    MenuItem(
        title: 'logout', 
        subTitle: 'Logout app', 
        link: 'logout', 
        icon: Icons.logout
    ),
];