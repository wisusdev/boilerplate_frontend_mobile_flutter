import 'package:flutter/material.dart';

class MenuItem {
  	final String title;
  	final String subTitle;
  	final String link;
  	final IconData icon;

  	const MenuItem({
		required this.title,
		required this.subTitle,
		required this.link,
		required this.icon
  	});
}

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
];