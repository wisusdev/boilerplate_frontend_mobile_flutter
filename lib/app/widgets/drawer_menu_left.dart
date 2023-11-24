import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/helpers/text.dart';
import 'package:todolist_flutter/app/menu.dart';

class DrawerMenuLeft extends StatefulWidget {
    final GlobalKey<ScaffoldState> scaffoldKey;

	const DrawerMenuLeft({super.key, required this.scaffoldKey});

  	@override
  	State<DrawerMenuLeft> createState() => _DrawerMenuLeftState();
}

class _DrawerMenuLeftState extends State<DrawerMenuLeft> {

	int _selectedIndex = 0;

  	@override
  	Widget build(BuildContext context) {

		final hasNotch = MediaQuery.of(context).viewPadding.top > 35;

		return NavigationDrawer(
			selectedIndex: _selectedIndex,
			
			onDestinationSelected: (index) { 
				setState(() {
					_selectedIndex = index;
				});

				final menuItem = appMenuItems[index];
				Navigator.of(context).pushNamed(menuItem.link);
                Scaffold.of(context).closeDrawer();
                //widget.scaffoldKey.currentState?.closeDrawer();
			},

			children: [
				Padding(
					padding: EdgeInsets.fromLTRB(28, hasNotch ? 0 : 20, 16, 10),
					child: const Text('Main'),
				),

				...appMenuItems.map((item) => NavigationDrawerDestination(
					icon: Icon(item.icon), 
					label: Text(capitalizeText(Location.of(context)!.trans(item.title))),
				))
			],
		);
  	}
}