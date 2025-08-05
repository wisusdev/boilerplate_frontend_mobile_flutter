import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/auth_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/app.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/auth/login.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/snack_bar.dart';

class AuthForgotPassword extends StatefulWidget {
  const AuthForgotPassword({super.key});

  @override
  State<AuthForgotPassword> createState() => _AuthForgotPasswordState();
}

class _AuthForgotPasswordState extends State<AuthForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  Map<String, dynamic> errorMessage = {'email': null};
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
                padding: EdgeInsets.only(left: 20, right: 20, top: size.height * 0.08, bottom: size.height * 0.06),
                child: Center(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildLogo(),
                          const SizedBox(height: 20),
                          _buildTitle(context),
                          const SizedBox(height: 20),
                          _buildEmailField(context),
                          const SizedBox(height: 40),
                          _buildSendButton(context),
                          const SizedBox(height: 40),
                          _buildLoginButton(context),
                        ],
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
    return const Image(image: AssetImage(logoApp), width: 80, height: 80);
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      Location.of(context)!.trans('resetPassword'),
      style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w100),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: Location.of(context)!.trans('email'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return Location.of(context)!.trans('validation.emailRequired');
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return Location.of(context)!.trans('validation.emailEmail');
        }
        if (errorMessage['email'] != null) {
          return errorMessage['email'];
        }
        return null;
      },
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: _handleForgotPassword,
        child: Text(
          Location.of(context)!.trans('sendPasswordResetLink'),
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

  void _handleForgotPassword() async {
    resetErrorMessages();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, String> data = {
        'type': 'users',
        'email': _emailController.text,
      };
      Map<String, dynamic> responseForgotPassword = await AuthService().forgotPassword(data: data);

      setState(() {
        _isLoading = false;
      });

      if (responseForgotPassword.containsKey('data')) {
        toastSuccess(context, Location.of(context)!.trans('message.emailVerificationSent'));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthLogin()));
      }

      if (responseForgotPassword.containsKey('errors')) {
        var errors = responseForgotPassword['errors'];
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
      errorMessage = {'email': null};
    });
  }
}
