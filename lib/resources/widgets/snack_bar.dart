import 'package:flutter/material.dart';

getScafoldMessage(BuildContext context, String message, {Duration duration = const Duration(seconds: 5), Color backgroundColor = Colors.blue}) {
	ScaffoldMessenger.of(context).showSnackBar(
		SnackBar(
			content: Text(message),
			duration: duration,
			backgroundColor: backgroundColor, // Personaliza el color de fondo
			behavior: SnackBarBehavior.floating, // Puedes cambiar el comportamiento según tus necesidades
			action: SnackBarAction(
				label: 'Cerrar',
				onPressed: () {
					// Acción a realizar cuando se presiona el botón de acción
					//ScaffoldMessenger.of(context).hideCurrentSnackBar();
				},
			),
		),
	);
}