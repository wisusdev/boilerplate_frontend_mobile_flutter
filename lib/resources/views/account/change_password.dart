import 'package:boilerplate_frontend_mobile_flutter/app/helpers/error_manager.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/http/controllers/account_controller.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
    const ChangePassword({super.key});

    @override
    State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
    final _formKey = GlobalKey<FormState>();
    
    final AccountController _accountController = AccountController();
    final TextEditingController _currentPasswordController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _passwordConfirmationController = TextEditingController();
    String _userId = '';
    bool _isLoading = false;

    final ErrorManager errorManager = ErrorManager(initialErrors: {
        'current_password': null,
        'password': null,
        'password_confirmation': null,
    });

    @override
    void initState() {
        super.initState();

        SharedPreferences.getInstance().then((prefs) {
            var userJson = prefs.getString('user');
            var userId = prefs.getString('user_key');

            if (userJson != null) {
                setState(() {
                    _userId = userId ?? '';
                });
            }
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
                title: Text('Change Password', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                backgroundColor: Theme.of(context).colorScheme.primary,
            ),

            body: Stack(
                children: [
                    SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                    children: [

                                        TextFormField(
                                            controller: _currentPasswordController,
                                            decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('oldPassword')),
                                            obscureText: true,
                                            validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                    return Location.of(context)!.trans('validation.thisFieldIsRequired');
                                                }

                                                if (errorManager.errors['current_password'] != null) {
                                                    return errorManager.errors['current_password'];
                                                }

                                                return null;
                                            },
                                        ),

                                        const SizedBox(height: 20),
                                        const Divider(),
                                        const SizedBox(height: 20),

                                        TextFormField(
                                            controller: _passwordController,
                                            keyboardType: TextInputType.visiblePassword,
                                            obscureText: true,
                                            decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('newPassword')),
                                            validator: (value) {
                                                if (value!.isEmpty) {
                                                    return Location.of(context)!.trans('validation.thisFieldIsRequired');
                                                }

                                                if (value.length < 8) {
                                                    return Location.of(context)!.trans('validation.passwordMin');
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
                                            decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('confirmPassword')),
                                            obscureText: true,
                                            validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                    return Location.of(context)!.trans('validation.thisFieldIsRequired');
                                                }
                                                
                                                if (value != _passwordController.text) {
                                                    return Location.of(context)!.trans('validation.passwordConfirmed');
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
                                                    setState(() {
                                                        _isLoading = true;
                                                    });

                                                    Map<String, String> data = {
                                                        "type": "change-password",
                                                        'id': _userId,
                                                        'current_password': _currentPasswordController.text,
                                                        'password': _passwordController.text,
                                                        'password_confirmation': _passwordConfirmationController.text,
                                                    };

                                                    _accountController.changePassword(context, data, setErrorMessages).then((_) {
                                                        setState(() {
                                                            _isLoading = false;
                                                            _currentPasswordController.clear();
                                                            _passwordController.clear();
                                                            _passwordConfirmationController.clear();
                                                        });
                                                    });
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

                                        const SizedBox(height: 20),
                                    ],
                                ),
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
                'current_password': null,
                'password': null,
                'password_confirmation': null,
            });
        });
    }

}