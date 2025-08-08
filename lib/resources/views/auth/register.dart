import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/auth_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/app.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/auth/login.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/input_decoration.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/snack_bar.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/responsive_layout.dart';

class AuthRegister extends StatefulWidget {
  const AuthRegister({super.key});

  @override
  State<AuthRegister> createState() => _AuthRegisterState();
}

class _AuthRegisterState extends State<AuthRegister> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Map<String, dynamic> errorMessage = {
    'username': null,
    'first_name': null,
    'last_name': null,
    'email': null,
    'password': null,
    'password_confirmation': null,
  };

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Navigator.pushNamed(context, 'setting'),
                  tooltip: Location.of(context)!.trans('settings'),
                ),
              ),
              Center(
                child: Container(
                  width: ResponsiveLayout.containerMaxWidthSize(context, mobile: 0.9, tablet: 0.5, desktop: 0.3, largeDesktop: 0.5),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: size.height * 0.04),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLogo(),
                            const SizedBox(height: 40),
                            _buildTitle(context),
                            const SizedBox(height: 10),
                            _buildUsernameField(context),
                            const SizedBox(height: 10),
                            _buildNameFields(context),
                            const SizedBox(height: 10),
                            _buildEmailField(context),
                            const SizedBox(height: 10),
                            _buildPasswordField(context),
                            const SizedBox(height: 10),
                            _buildConfirmPasswordField(context),
                            const SizedBox(height: 40),
                            _buildRegisterButton(context),
                            const SizedBox(height: 40),
                            _buildLoginButton(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLoading
                    ? Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: AssetImage(logoApp), width: 80, height: 80),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      Location.of(context)!.trans('register'),
      style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w100),
    );
  }

  Widget _buildUsernameField(BuildContext context) {
    return TextFormField(
      controller: _usernameController,
      decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('userName')),
      validator: (value) {
        if (value!.isEmpty) {
          return Location.of(context)!.trans('validation.thisFieldIsRequired');
        }
        if (errorMessage['username'] != null) {
          return errorMessage['username'];
        }
        return null;
      },
    );
  }

  Widget _buildNameFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstnameController,
            decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('firstName')),
            validator: (value) {
              if (value!.isEmpty) {
                return Location.of(context)!.trans('validation.thisFieldIsRequired');
              }
              if (errorMessage['first_name'] != null) {
                return errorMessage['first_name'];
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: _lastnameController,
            decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('lastName')),
            validator: (value) {
              if (value!.isEmpty) {
                return Location.of(context)!.trans('validation.thisFieldIsRequired');
              }
              if (errorMessage['last_name'] != null) {
                return errorMessage['last_name'];
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('email')),
      validator: (value) {
        if (value!.isEmpty) {
          return Location.of(context)!.trans('validation.thisFieldIsRequired');
        }
        if (errorMessage['email'] != null) {
          return errorMessage['email'];
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return Location.of(context)!.trans('validation.invalidEmail');
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('password')),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return Location.of(context)!.trans('validation.thisFieldIsRequired');
        }
        if (errorMessage['password'] != null) {
          return errorMessage['password'];
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('confirmPassword')),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return Location.of(context)!.trans('validation.thisFieldIsRequired');
        }
        if (_passwordController.text != _confirmPasswordController.text) {
          return Location.of(context)!.trans('validation.passwordConfirmed');
        }
        if (errorMessage['password_confirmation'] != null) {
          return errorMessage['password_confirmation'];
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () => _handleRegister(context),
        child: Text(
          Location.of(context)!.trans('registerMe'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Sofia",
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AuthLogin()),
              (route) => false,
            );
          },
          child: Text(
            Location.of(context)!.trans('login'),
            style: const TextStyle(fontFamily: 'Sofia'),
          ),
        ),
      ],
    );
  }

  void _handleRegister(BuildContext context) async {
    resetErrorMessages();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> data = {
        'type': 'users',
        'username': _usernameController.text,
        'first_name': _firstnameController.text,
        'last_name': _lastnameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'password_confirmation': _confirmPasswordController.text,
      };

      Map<String, dynamic> registerResponse = await AuthService().register(data: data);

      setState(() {
        _isLoading = false;
      });

      if (registerResponse.containsKey('data') && context.mounted) {
        toastSuccess(context, Location.of(context)!.trans('recordCreated'));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthLogin()),
          (route) => false,
        );
      }

      if (registerResponse.containsKey('errors') && context.mounted) {
        var errors = registerResponse['errors'];
        if (errors is List) {
          for (var error in errors) {
            String title = error['title'];
            List<String> titleList = title.split('.');
            errorMessage[titleList.last] = Location.of(context)!.trans(error['detail']);
          }
        }
        toastDanger(context, Location.of(context)!.trans('errorAsOccurred'));
        _formKey.currentState!.validate();
      }
    }
  }

  void resetErrorMessages() {
    setState(() {
      errorMessage = {
        'username': null,
        'first_name': null,
        'last_name': null,
        'email': null,
        'password': null,
        'password_confirmation': null,
      };
    });
  }
}
