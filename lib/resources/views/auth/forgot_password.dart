import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/services/auth_service.dart';
import 'package:todolist_flutter/resources/widgets/snack_bar.dart';

class AuthForgotPassword extends StatefulWidget {
  	const AuthForgotPassword({super.key});

  	@override
  	State<AuthForgotPassword> createState() => _AuthForgotPasswordState();
}

class _AuthForgotPasswordState extends State<AuthForgotPassword> {
	final _formKey = GlobalKey<FormState>();

  	
    final TextEditingController _emailController = TextEditingController();
  	
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
                                        },
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

                                                forgotPassword(context);
                                            }
                                        },
                                        child: Text(Location.of(context)!.trans('resetPwd')),
                                    ),
                                ],
                            ),
                        ),
                    ),
                ),
            ),
    	);
  	}

    void forgotPassword(context) async {

        setState(() {
        });

        Map<String, dynamic> data = {
            'email': _emailController.text,
        };

        var response = await AuthService().forgotPassword(data);
        if(response['user_found']){
            getScafoldMessage(context, response['message']);
            Navigator.pushNamed(context, 'login');
        } else {
            getScafoldMessage(context, response['message']);
        }

        setState(() {
        });
    }
}
