import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';

class ResponseValidator {
  /// Resultado de la validación de respuesta
  static ResponseValidationResult validateResponse(Map<String, dynamic> data) {
    // Caso 1: Respuesta exitosa con datos
    if (data.containsKey('response') && data['response'] != null && data['response']['data'] != null) {
      return ResponseValidationResult(isSuccess: true, data: data['response']['data'], errorMessage: null);
    }

    // Caso 2: Respuesta con errores estructurados
    if (data.containsKey('response') && data['response'] != null && data['response']['errors'] != null) {
      final errors = data['response']['errors'];
      String errorMessage = _extractErrorMessage(errors);
      return ResponseValidationResult(isSuccess: false, data: null, errorMessage: errorMessage, errors: errors);
    }

    // Caso 3: Respuesta exitosa directa (sin estructura 'response')
    if (data.containsKey('data')) {
      return ResponseValidationResult(isSuccess: true, data: data['data'], errorMessage: null);
    }

    // Caso 4: Errores directos (sin estructura 'response')
    if (data.containsKey('errors')) {
      final errors = data['errors'];
      String errorMessage = _extractErrorMessage(errors);
      return ResponseValidationResult(isSuccess: false, data: null, errorMessage: errorMessage, errors: errors);
    }

    // Caso 5: Error desconocido
    return ResponseValidationResult(isSuccess: false, data: null, errorMessage: 'Ocurrió un error desconocido.');
  }

  /// Extrae el mensaje de error más relevante de la estructura de errores
  static String _extractErrorMessage(dynamic errors) {
    if (errors is List && errors.isNotEmpty) {
      final firstError = errors[0];
      if (firstError is Map<String, dynamic>) {
        return firstError['detail'] ?? firstError['message'] ?? 'Ocurrió un error en el servidor.';
      }
      return firstError.toString();
    }

    if (errors is Map<String, dynamic>) {
      return errors['detail'] ?? errors['message'] ?? 'Ocurrió un error en el servidor.';
    }

    return 'Ocurrió un error en el servidor.';
  }

  /// Procesa errores de campos específicos para formularios
  static Map<String, String?> processFieldErrors(dynamic errors, Map<String, String?> fieldMap, BuildContext? context) {
    Map<String, String?> errorMessages = Map.from(fieldMap);

    if (errors is List) {
      for (var error in errors) {
        if (error is Map<String, dynamic> && error.containsKey('title')) {
          String title = error['title'];
          List<String> titleList = title.split('.');
          String fieldName = titleList.last;

          if (errorMessages.containsKey(fieldName)) {
            String errorDetail = error['detail'] ?? 'Error de validación';
            errorMessages[fieldName] = context != null ? Location.of(context)!.trans(errorDetail) : errorDetail;
          }
        }
      }
    }

    return errorMessages;
  }
}

/// Resultado base de validación de respuesta
class ResponseValidationResult {
  final bool isSuccess;
  final dynamic data;
  final String? errorMessage;
  final dynamic errors;

  ResponseValidationResult({required this.isSuccess, this.data, this.errorMessage, this.errors});
}
