import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/app.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/error_manager.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/input_decoration.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/http/controllers/auth_controller.dart';

class AuthLogin extends StatefulWidget {
	const AuthLogin({super.key});
	
	@override
  	State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  	final _formKey = GlobalKey<FormState>();

    final AuthController authController = AuthController();
    final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();
    bool _isLoading = false;

    final ErrorManager errorManager = ErrorManager(initialErrors: {
        'email': null,
        'password': null,
    });

  	@override
  	Widget build(BuildContext context) {
        final size = MediaQuery.of(context).size;

		return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                body: Stack(
                    children: [
                        SingleChildScrollView(
                            reverse: true,
                            padding: EdgeInsets.only(left: 20, right: 20, top: size.height * 0.08, bottom: size.height * 0.06),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Column(
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
                                                
                                                Text(Location.of(context)!.trans('welcomeBack'), style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w100)),
                                                
                                                const SizedBox(height: 10),
                                                
                                                TextFormField(
                                                    controller: _emailController,
                                                    keyboardType: TextInputType.emailAddress,
                                                    decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('email')),
                                                    validator: (value) {
                                                        if (value!.isEmpty) {
                                                            return Location.of(context)!.trans('validation.emailRequired');
                                                        }

                                                        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                                            return Location.of(context)!.trans('validation.invalidEmail');
                                                        }

                                                        if(errorManager.errors['email'] != null){
                                                            return errorManager.errors['email'];
                                                        }
                                                        
                                                        return null;
                                                    },
                                                ),

                                                const SizedBox(height: 10),

                                                TextFormField(
                                                    controller: _passwordController,
                                                    keyboardType: TextInputType.visiblePassword,
                                                    obscureText: true,
                                                    decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('password')),
                                                    validator: (value) {
                                                        if (value!.isEmpty) {
                                                            return 'Por favor ingresa tu contraseña';
                                                        }

                                                        if (value.length < 8) {
                                                            return 'La contraseña debe tener al menos 8 caracteres';
                                                        }

                                                        if(errorManager.errors['password'] != null){
                                                            return errorManager.errors['password'];
                                                        }

                                                        return null;
                                                    }
                                                ),

                                                const SizedBox(height: 20),
                                                
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                        InkWell(
                                                            onTap: () {
                                                                Navigator.pushNamed(context, 'forgot_password');
                                                            },
                                                            child: Text(Location.of(context)!.trans('forgotPassword'), style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Sofia')),
                                                        ),
                                                    ],
                                                ),
                                                
                                                const SizedBox(height: 40),

                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                                        padding: const EdgeInsets.all(13),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    ),
                                                    child: Center(
                                                        child: Text(Location.of(context)!.trans('login'), style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: "Sofia",
                                                            color: Theme.of(context).colorScheme.onPrimary,
                                                            fontSize: 18.0
                                                        ))
                                                    ),
                                                    onPressed: () {
                                                        resetErrorMessages();

                                                        if (_formKey.currentState!.validate()) {

                                                            setState(() {
                                                                _isLoading = true;
                                                            });

                                                            Map<String, String> data = {
                                                                'type': 'users',
                                                                'email': _emailController.text,
                                                                'password': _passwordController.text,
                                                            };

                                                            authController.login(context, data, setErrorMessages).then((value) {
                                                                setState(() {
                                                                    _isLoading = false;
                                                                });
                                                            });
                                                        }
                                                    },
                                                ),
                                            ],
                                        ),

                                        const SizedBox(height: 40),

                                        Column(
                                            children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                        InkWell(
                                                            onTap: () {
                                                                Navigator.pushNamed(context, 'register');
                                                            },
                                                            child: Text(Location.of(context)!.trans('registerHere'), style: const TextStyle(fontFamily: 'Sofia'))
                                                        ),
                                                    ],
                                                ),
                                            ],
                                        )
                                    ],
                                ),
                            ),
                        ),
                        if (_isLoading)
                            Container(
                                color: Colors.black.withAlpha(128), // 128 es equivalente a 0.5 en opacidad
                                child: const Center(
                                    child: CircularProgressIndicator(),
                                ),
                            ),
                    ],
                ),
            ),
        );
    }

    void setErrorMessages(Map<String, dynamic> errors) {
        setState(() {
            errorManager.setErrors(errors);
        });
    }

    resetErrorMessages(){
        setState(() {
            errorManager.setErrors({
                'email': null,
                'password': null,
            });
        });
    }
}