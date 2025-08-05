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
        body: SafeArea(
          child: Stack(
            children: [
              // Botón de configuración en la parte superior derecha
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Navigator.pushNamed(context, 'setting'),
                  tooltip: 'Configuración',
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: size.height * 0.04),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildLogo(),
                          const SizedBox(height: 32),
                          _buildWelcomeText(context),
                          const SizedBox(height: 16),
                          _buildEmailField(context),
                          const SizedBox(height: 12),
                          _buildPasswordField(context),
                          const SizedBox(height: 8),
                          _buildForgotPassword(context),
                          const SizedBox(height: 32),
                          _buildLoginButton(context),
                          const SizedBox(height: 32),
                          _buildRegister(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLoading ? Container(color: Colors.black, child: const Center(child: CircularProgressIndicator())) : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return const Image(image: AssetImage(logoApp), width: 80, height: 80);
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Text(
      Location.of(context)!.trans('welcomeBack'),
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
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
        if (errorManager.errors['email'] != null) {
          return errorManager.errors['email'];
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
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
        if (errorManager.errors['password'] != null) {
          return errorManager.errors['password'];
        }
        return null;
      },
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, 'forgot_password'),
        child: Text(
          Location.of(context)!.trans('forgotPassword'),
          style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Sofia'),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: _handleLogin,
        child: Text(
          Location.of(context)!.trans('login'),
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

  Widget _buildRegister(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(Location.of(context)!.trans('dontHaveAccount'), style: const TextStyle(fontFamily: 'Sofia')),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, 'register'),
          child: Text(Location.of(context)!.trans('registerHere'), style: const TextStyle(fontFamily: 'Sofia')),
        ),
      ],
    );
  }

  void _handleLogin() {
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
  }

  void setErrorMessages(Map<String, dynamic> errors) {
    setState(() {
      errorManager.setErrors(errors);
    });
  }

  void resetErrorMessages() {
    setState(() {
      errorManager.setErrors({
        'email': null,
        'password': null,
      });
    });
  }
}
