import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_flutter/app/providers/auth_provider.dart';
import 'package:todolist_flutter/resources/views/auth/login.dart';

class AuthGuard extends StatelessWidget {
	final Widget child;

	const AuthGuard({Key? key, required this.child}) : super(key: key);

	@override
	Widget build(BuildContext context)  {
		final authService = Provider.of<AuthProvider>(context);

		return FutureBuilder<bool>(
	  		future: authService.isUserAuthenticated(),
	  		builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) {
					return const CircularProgressIndicator();
				} else if (snapshot.hasData && snapshot.data == true) {
					return child;
				} else {
					return const AuthLogin();
				}
	  		},
		);
	}
}