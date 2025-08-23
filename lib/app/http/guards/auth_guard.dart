import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/providers/auth_provider.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/auth/login.dart';

// Widget que actúa como un guardián de autenticación
class AuthGuard extends StatelessWidget {
    // Widget hijo que se mostrará si el usuario está autenticado
    final Widget child;

    // Constructor que recibe el widget hijo como parámetro obligatorio
    const AuthGuard({Key? key, required this.child}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        // Instancia del proveedor de autenticación
        final AuthProvider authProvider = AuthProvider();

        // Utiliza FutureBuilder para manejar la verificación de autenticación
        return FutureBuilder<bool>(
            // Llama al método que verifica si el usuario está autenticado
            future: authProvider.isUserAuthenticated(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                // Muestra un indicador de carga mientras se espera el resultado
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                }

                // Si el usuario está autenticado, muestra el widget hijo
                return snapshot.hasData && snapshot.data == true ? child : _redirectToLogin(context);
            },
        );
    }

    // Si el usuario no está autenticado, redirige a la pantalla de inicio de sesión
    Widget _redirectToLogin(BuildContext context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AuthLogin()),
                (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
            );
        });

        // Devuelve un contenedor vacío mientras se realiza la redirección
        return Container();
    }
}