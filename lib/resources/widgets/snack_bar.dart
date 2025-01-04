import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';

getScafoldMessage(BuildContext context, String message, {Duration duration = const Duration(seconds: 5), Color backgroundColor = Colors.blue}) {
	ScaffoldMessenger.of(context).showSnackBar(
		SnackBar(
			content: Text(message),
			duration: duration,
			backgroundColor: backgroundColor, // Personaliza el color de fondo
			behavior: SnackBarBehavior.floating, // Puedes cambiar el comportamiento según tus necesidades
			action: SnackBarAction(
				label: Location.of(context)!.trans('close'),
				onPressed: () {
					// Acción a realizar cuando se presiona el botón de acción
					//ScaffoldMessenger.of(context).hideCurrentSnackBar();
				},
			),
		),
	);
}

toastDanger(BuildContext context, String message) {
    getScafoldMessage(context, message, backgroundColor: Colors.red);
}

toastSuccess(BuildContext context, String message) {
    getScafoldMessage(context, message, backgroundColor: Colors.green);
}

toastWarning(BuildContext context, String message) {
    getScafoldMessage(context, message, backgroundColor: Colors.orange);
}

toastInfo(BuildContext context, String message) {
    getScafoldMessage(context, message, backgroundColor: Colors.blue);
}

toastPrimary(BuildContext context, String message) {
    getScafoldMessage(context, message, backgroundColor: Colors.blue);
}

toastSecondary(BuildContext context, String message) {
    getScafoldMessage(context, message, backgroundColor: Colors.blue);
}