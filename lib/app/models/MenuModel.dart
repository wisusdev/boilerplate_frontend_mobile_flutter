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