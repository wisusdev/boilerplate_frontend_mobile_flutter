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
		title: 'sign_in', 
		subTitle: 'Login view', 
		link: 'login', 
		icon: Icons.login
	),

	MenuItem(
		title: 'profile', 
		subTitle: 'Profile view', 
		link: 'profile', 
		icon: Icons.person
	),

    MenuItem(
        title: 'sign_up', 
        subTitle: 'Register view', 
        link: 'register', 
        icon: Icons.app_registration
    ),

	MenuItem(
		title: 'settings', 
		subTitle: 'Settings app', 
		link: 'setting', 
		icon: Icons.settings
	),
];