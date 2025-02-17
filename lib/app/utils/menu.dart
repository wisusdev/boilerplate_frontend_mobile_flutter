import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/interfaces/local/menu_model.dart';


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
	)
];