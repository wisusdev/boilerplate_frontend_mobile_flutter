import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/response_validator.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/error_manager.dart';

/// Mixin para manejo centralizado de estados de UI (loading, error, success)
mixin UIStateMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  String? _errorMessage;
  ErrorManager? _errorManager;

  /// Getter para estado de carga
  bool get isLoading => _isLoading;

  /// Getter para mensaje de error
  String? get errorMessage => _errorMessage;

  /// Getter para manager de errores
  ErrorManager? get errorManager => _errorManager;

  /// Inicializa el error manager con campos específicos
  void initializeErrorManager(Map<String, String?> initialErrors) {
    _errorManager = ErrorManager(initialErrors: initialErrors);
  }

  /// Establece el estado de carga
  void setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  /// Establece un mensaje de error
  void setError(String? error) {
    if (mounted) {
      setState(() {
        _errorMessage = error;
      });
    }
  }

  /// Limpia el mensaje de error
  void clearError() {
    if (mounted) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  /// Procesa una respuesta del servidor usando ResponseValidator
  ResponseValidationResult processServerResponse(Map<String, dynamic> data) {
    final result = ResponseValidator.validateResponse(data);
    
    if (!result.isSuccess) {
      setError(result.errorMessage);
      
      // Si hay error manager configurado, procesar errores de campos
      if (_errorManager != null && result.errors != null) {
        _errorManager!.processServerErrors(data, context, showToast: false);
      }
    } else {
      clearError();
    }
    
    return result;
  }

  /// Ejecuta una operación asíncrona con manejo automático de loading y errores
  Future<T?> executeWithLoading<T>(
    Future<T> operation, {
    String? errorMessage,
    bool clearErrorOnStart = true,
  }) async {
    if (clearErrorOnStart) clearError();
    setLoading(true);
    
    try {
      final result = await operation;
      setLoading(false);
      return result;
    } catch (e) {
      setLoading(false);
      setError(errorMessage ?? 'Ocurrió un error inesperado');
      return null;
    }
  }

  /// Widget builder para mostrar loading
  Widget buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  /// Widget builder para mostrar error
  Widget buildError(String message, {VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message, 
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Widget builder para contenido vacío
  Widget buildEmpty(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(message),
      ),
    );
  }

  /// Builder principal que maneja automáticamente los estados
  Widget buildWithStates({
    required Widget Function() contentBuilder,
    Widget Function()? loadingBuilder,
    Widget Function(String)? errorBuilder,
    VoidCallback? onRetry,
  }) {
    if (_isLoading) {
      return loadingBuilder?.call() ?? buildLoading();
    }
    
    if (_errorMessage != null) {
      return errorBuilder?.call(_errorMessage!) ?? buildError(_errorMessage!, onRetry: onRetry);
    }
    
    return contentBuilder();
  }
}
