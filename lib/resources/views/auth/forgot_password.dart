import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';

class AuthForgotPassword extends StatefulWidget {
  	const AuthForgotPassword({super.key});

  	@override
  	State<AuthForgotPassword> createState() => _AuthForgotPasswordState();
}

class _AuthForgotPasswordState extends State<AuthForgotPassword> {
	final _formKey = GlobalKey<FormState>();

  	final TextEditingController _emailController = TextEditingController();
  	
	bool _isEmailValid = false;

  	@override
  	void dispose() {
    	_emailController.dispose();
    	super.dispose();
  	}

  	void _validateEmail(String email) {
		// Validar el correo electrónico aquí
		// Puedes usar una expresión regular o cualquier otra lógica de validación
		setState(() {
		_isEmailValid = email.isNotEmpty;
		});
  	}

  	@override
  	Widget build(BuildContext context) {
		final sizeWith = MediaQuery.of(context).size.width;

    	return Scaffold(
      		appBar: AppBar(
        		title: const Text('Forgot Password'),
      		),
      		body: Center(
                child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Padding(
                        padding: EdgeInsets.only(top: sizeWith * 0.05, bottom: 0, left: 20, right: 20),
                        child: Form(
                            key: _formKey,
                            child: Column(
                                //mainAxisAlignment: MainAxisAlignment.center,
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

                                    Text(Location.of(context)!.trans('forgotPasswordInstructions'), style: const TextStyle( fontSize: 16)),

                                    const SizedBox(height: 20),

                                    TextField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                            labelText: Location.of(context)!.trans('email'),
                                            prefixIcon: const Icon(Icons.email_outlined),
                                            border: const OutlineInputBorder(),
                                        ),
                                        onChanged: _validateEmail,
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
                                        onPressed: _isEmailValid ? () {} : null,
                                        child: Text(Location.of(context)!.trans('reset_pwd')),
                                    ),
                                ],
                            ),
                        ),
                    ),
                ),
            ),
    	);
  	}
}
