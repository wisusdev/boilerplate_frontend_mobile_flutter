import 'package:boilerplate_frontend_mobile_flutter/app/helpers/error_manager.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/input_decoration.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
    const ChangePassword({super.key});

    @override
    State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController _currentPasswordController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _passwordConfirmationController = TextEditingController();
    bool _isLoading = false;

    final ErrorManager errorManager = ErrorManager(initialErrors: {
        'current_password': null,
        'password': null,
        'password_confirmation': null,
    });

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
                title: Text('Change Password', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                backgroundColor: Theme.of(context).colorScheme.primary,
            ),

            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            children: [

                                TextFormField(
                                    controller: _currentPasswordController,
                                    decoration: inputDecorationStyle(labelText: 'Current Password'),
                                    obscureText: true,
                                    validator: (value) {
                                        if (value == null || value.isEmpty) {
                                            return 'Please enter your current password';
                                        }

                                        if (errorManager.errors['current_password'] != null) {
                                            return errorManager.errors['current_password'];
                                        }

                                        return null;
                                    },
                                ),

                                const SizedBox(height: 20),

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

                                TextFormField(
                                    controller: _passwordConfirmationController,
                                    decoration: inputDecorationStyle(labelText: 'Confirm New Password'),
                                    obscureText: true,
                                    validator: (value) {
                                        if (value == null || value.isEmpty) {
                                            return 'Please confirm your new password';
                                        }
                                        
                                        if (value != _passwordController.text) {
                                            return 'Passwords do not match';
                                        }

                                        if (errorManager.errors['password_confirmation'] != null) {
                                            return errorManager.errors['password_confirmation'];
                                        }

                                        return null;
                                    },
                                ),
                                
                                const SizedBox(height: 20),

                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        padding: const EdgeInsets.all(13),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    ),
                                    onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                            // Process data
                                        }
                                    },
                                    child: Center(
                                        child: Text(Location.of(context)!.trans('save'), style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Sofia",
                                            color: Theme.of(context).colorScheme.onPrimary,
                                            fontSize: 18.0
                                        ))
                                    ),
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}