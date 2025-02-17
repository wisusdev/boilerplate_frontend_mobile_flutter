import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/providers/auth_provider.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/auth/login.dart';

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
					WidgetsBinding.instance.addPostFrameCallback((_) {
							Navigator.of(context).pushAndRemoveUntil(
								MaterialPageRoute(builder: (context) => const AuthLogin()),
								(Route<dynamic> route) => false,
							);
					});
                    
					return Container(); // Return an empty container while the navigation happens
				}
	  		},
		);
	}
}