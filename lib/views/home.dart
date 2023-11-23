import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/helpers/text.dart';
import 'package:todolist_flutter/app/widgets/drawer_menu_left.dart';
import 'package:todolist_flutter/config/app.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
	return Scaffold(

		appBar: AppBar(
		  	title: Text(
			  	capitalizeText(Location.of(context)!.trans('home')),
			  	style: TextStyle(
				  	color: Theme.of(context).colorScheme.onPrimary
			  	)
		  	),
			iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
		  	backgroundColor: Theme.of(context).colorScheme.primary,
		),

		body: Center(
			child: Text(appName),
		),

		floatingActionButton: FloatingActionButton(
			onPressed: () {},
			backgroundColor: Theme.of(context).colorScheme.primary,
			child: Icon(Icons.qr_code_scanner, color: Theme.of(context).colorScheme.onPrimary),
		),

		drawer: const DrawerMenuLeft(),
	);
  }
}