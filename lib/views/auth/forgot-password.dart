import 'package:flutter/material.dart';

class AuthForgotPassword extends StatefulWidget {
  const AuthForgotPassword({super.key});

  @override
  State<AuthForgotPassword> createState() => _AuthForgotPasswordState();
}

class _AuthForgotPasswordState extends State<AuthForgotPassword> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              onChanged: _validateEmail,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isEmailValid ? () {} : null,
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
