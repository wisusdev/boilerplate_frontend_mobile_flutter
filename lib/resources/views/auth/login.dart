import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/services/auth_service.dart';

class AuthLogin extends StatefulWidget {
	const AuthLogin({super.key});
	
	@override
  	State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  	final _formKey = GlobalKey<FormState>();
    
    bool _isLoading = false;

    final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();

  	@override
  	Widget build(BuildContext context) {

        final sizeWith = MediaQuery.of(context).size.width;

		return Scaffold(
            appBar: AppBar(
				title: const Text('Inicio de sesión'),
			),
	  		body: Center(
				child: Container(
					constraints: const BoxConstraints(maxWidth: 400),
					child: Stack(
						children: [
							SingleChildScrollView(
								padding: EdgeInsets.only(top: sizeWith * 0.05, bottom: 0, left: 20, right: 20),
								child: Form(
									key: _formKey,
									child: Column(
										mainAxisAlignment: MainAxisAlignment.center,
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [                        
											const Row(
												mainAxisAlignment: MainAxisAlignment.center,
												children: [
													Image(
														image: AssetImage('lib/assets/images/wisus-logo.png'), 
														width: 80,
														height: 80,
													),
												],
											),
									
											const SizedBox(height: 20),
															
											//const Text('Login', style: TextStyle(fontFamily: 'bool', fontSize: 22, fontWeight: FontWeight.bold)),
										
											const SizedBox(height: 20),
									
											TextFormField(
												controller: _emailController,
												decoration: InputDecoration(
													labelText: Location.of(context)!.trans('email'), 
													prefixIcon: const Icon(Icons.email_outlined),
													border: const OutlineInputBorder(),
												),
												validator: (value) {
													if (value!.isEmpty) {
														return 'Por favor ingresa tu correo electrónico';
													}

													if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
														return 'Por favor ingresa un correo electrónico válido';
													}

													return null;
												}
											),
									
											const SizedBox(height: 20),
										
											TextFormField(
												controller: _passwordController,
												decoration: InputDecoration(
													labelText: Location.of(context)!.trans('password'),  
													prefixIcon: const Icon(Icons.lock_outline),
													border: const OutlineInputBorder(),
												),
												obscureText: true,
												validator: (value) {
													if (value!.isEmpty) {
														return 'Por favor ingresa tu contraseña';
													}

													if (value.length < 8) {
														return 'La contraseña debe tener al menos 8 caracteres';
													}

													return null;
												}
											),
									
											const SizedBox(height: 30),
										
											Row(
												mainAxisAlignment: MainAxisAlignment.end,
												children: [
													InkWell(
														onTap: () {
															Navigator.pushNamed(context, 'forgot_password');
														},
														child: Text(Location.of(context)!.trans('forgot_your_pwd')),
													)
												],
											),
										
											const SizedBox(height: 30),
										
											ElevatedButton(
												style: ElevatedButton.styleFrom(
													backgroundColor: Theme.of(context).colorScheme.onPrimary,
													foregroundColor: Theme.of(context).colorScheme.primary,
													minimumSize: const Size.fromHeight(45),
													shape: RoundedRectangleBorder(
														borderRadius: BorderRadius.circular(20),
													),
												),
												onPressed: (){
													if (_formKey.currentState!.validate()) {
														_formKey.currentState!.save();
														
														login();

														ScaffoldMessenger.of(context).showSnackBar(
															const SnackBar(content: Text('Procesando datos...'))
														);
													}
												}, 
												child: Text(Location.of(context)!.trans('sign_in'), style: const TextStyle(fontSize: 16))
											),    

											const SizedBox(height: 10),
										],
									),
								),
							),
							
							Positioned(
								child: Container(
									padding: EdgeInsets.only(top: sizeWith * 1.30),
									child: Row(
										mainAxisAlignment: MainAxisAlignment.center,
										children: [
											Text(Location.of(context)!.trans('you_dont_have_an_account')),
											InkWell(
												onTap: () {
													Navigator.pushNamed(context, 'register');
												},
												child: Text(' ${Location.of(context)!.trans('sign_up')}', style: const TextStyle(fontWeight: FontWeight.bold)),
											),
										],
									),
								)
							)
						]
					),
				),
			),
		);
  	}

    void login() async {
        setState(() {
            _isLoading = true;
        });

        Map<String, String> data = {
            'email': _emailController.text,
            'password': _passwordController.text,
        };

        var response = await AuthService().login(data);
        var body = json.decode(response.body);

        if (body['status']) {
            if (!mounted) return;
            Navigator.pushNamed(context, 'home');
        } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(body['message']))
            );
        }

        setState(() {
            _isLoading = false;
        });
    }
}
