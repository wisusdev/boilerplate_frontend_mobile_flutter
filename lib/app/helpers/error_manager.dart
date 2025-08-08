import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/response_validator.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/snack_bar.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';

class ErrorManager {
    Map<String, String?> _errors = {};

    ErrorManager({required Map<String, String?> initialErrors}) {
        _errors = initialErrors;
    }

    /// Establece errores específicos
    void setErrors(Map<String, String?> errors) {
        _errors = errors;
    }

    /// Reinicia errores al estado inicial
    void resetErrors(Map<String, String?> initialErrors) {
        _errors = initialErrors;
    }

    /// Obtiene todos los errores
    Map<String, String?> get errors => _errors;

    /// Obtiene un error específico por campo
    String? getError(String field) {
        return _errors[field];
    }

    /// Verifica si hay errores
    bool get hasErrors => _errors.values.any((error) => error != null);

    /// Limpia todos los errores
    void clearErrors() {
        _errors.updateAll((key, value) => null);
    }

    /// Procesa errores desde una respuesta del servidor usando ResponseValidator
    void processServerErrors(
        Map<String, dynamic> responseData, 
        BuildContext? context,
        {bool showToast = true}
    ) {
        final result = ResponseValidator.validateResponse(responseData);
        
        if (!result.isSuccess && result.errors != null) {
            final processedErrors = ResponseValidator.processFieldErrors(
                result.errors, 
                _errors, 
                context
            );
            setErrors(processedErrors);
            
            if (showToast && context != null && context.mounted) {
                toastDanger(context, Location.of(context)!.trans('errorAsOccurred'));
            }
        }
    }

    /// Establece un error específico para un campo
    void setFieldError(String field, String? error) {
        _errors[field] = error;
    }

    /// Limpia el error de un campo específico
    void clearFieldError(String field) {
        _errors[field] = null;
    }
}