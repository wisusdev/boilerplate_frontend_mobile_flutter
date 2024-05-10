import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/services/auth_service.dart';
import 'package:todolist_flutter/resources/widgets/snack_bar.dart';
import 'package:todolist_flutter/config/app.dart';

class AuthLogin extends StatefulWidget {
	const AuthLogin({super.key});
	
	@override
  	State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  	final _formKey = GlobalKey<FormState>();
    
    final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();

  	@override
  	Widget build(BuildContext context) {

        final sizeWith = MediaQuery.of(context).size.width;

		return Scaffold(
            appBar: AppBar(
				title: Text(Location.of(context)!.trans('welcomeBack')),
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
													Image(image: AssetImage(logoApp), width: 80, height: 80,),
												],
											),
									
											const SizedBox(height: 40),
															
											TextFormField(
												controller: _emailController,
                                                keyboardType: TextInputType.emailAddress,
												decoration: InputDecoration(
													labelText: Location.of(context)!.trans('email'),
													prefixIcon: const Icon(Icons.email_outlined),
													border: const OutlineInputBorder(),
												),
												validator: (value) {
													if (value!.isEmpty) {
                                                        return Location.of(context)!.trans('validation.emailRequired');
                                                    }

                                                    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                                        return Location.of(context)!.trans('validation.emailEmail');
                                                    }
                                                    
                                                    return null;
                                                }
                                            ),

                                            const SizedBox(height: 20),

                                            TextFormField(
                                                controller: _passwordController,
                                                keyboardType: TextInputType.visiblePassword,
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
                                                        child: Text(Location.of(context)!.trans('forgotPassword')),
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
                                                onPressed: () {
                                                    if (_formKey.currentState!.validate()) {
                                                        _formKey.currentState!.save();

                                                        login(context);

                                                        getScafoldMessage(context, 'Procesando datos...');
                                                    }
                                                },
                                                child: Text(Location.of(context)!.trans('login'), style: const TextStyle(fontSize: 16))
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
                                            Text(Location.of(context)!.trans('dontHaveAccount')),
                                            InkWell(
                                                onTap: () {
                                                    Navigator.pushNamed(context, 'register');
                                                },
                                                child: Text(' ${Location.of(context)!.trans('registerHere')}', style: const TextStyle(fontWeight: FontWeight.bold)),
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

    void login(context) async {
        Map<String, String> data = {
            'type': 'users',
            'email': _emailController.text,
            'password': _passwordController.text,
        };

        bool loginResponse = await AuthService().login(data: data);

        if(loginResponse){
            Navigator.pushNamed(context, 'home');
        } else {
            getScafoldMessage(context, 'Error al iniciar sesión');
        }
    }
}
