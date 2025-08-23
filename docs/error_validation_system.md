# Sistema de Validación de Errores - Documentación

## Descripción General

Este sistema proporciona una forma consistente y reutilizable de manejar errores, validaciones de respuesta y estados de UI en toda la aplicación Flutter.

## Componentes Principales

### 1. ResponseValidator (`lib/app/helpers/response_validator.dart`)

Clase estática que maneja toda la validación de respuestas del servidor.

#### Métodos principales:

- `validateResponse(Map<String, dynamic> data)`: Validación general de respuestas
- `processFieldErrors()`: Procesa errores específicos de campos de formulario
- `validateDeviceListResponse()`: Validación específica para listas de dispositivos
- `validateDisconnectDeviceResponse()`: Validación específica para desconexión de dispositivos

#### Ejemplo de uso:

```dart
final result = ResponseValidator.validateResponse(serverResponse);
if (result.isSuccess) {
  // Manejar éxito
  processData(result.data);
} else {
  // Manejar error
  showError(result.errorMessage);
}
```

### 2. ErrorManager (`lib/app/helpers/error_manager.dart`)

Maneja errores de campos específicos en formularios.

#### Métodos principales:

- `setErrors()`: Establece múltiples errores
- `processServerErrors()`: Procesa errores desde respuesta del servidor
- `getError()`: Obtiene error de un campo específico
- `hasErrors`: Verifica si hay errores
- `clearErrors()`: Limpia todos los errores

#### Ejemplo de uso:

```dart
final errorManager = ErrorManager(initialErrors: {
  'email': null,
  'password': null,
});

// Procesar errores del servidor
errorManager.processServerErrors(serverResponse, context);

// Verificar errores específicos
String? emailError = errorManager.getError('email');
```

### 3. UIStateMixin (`lib/app/helpers/ui_state_mixin.dart`)

Mixin que proporciona manejo automático de estados de UI (loading, error, content).

#### Métodos principales:

- `setLoading()`: Controla estado de carga
- `setError()`: Establece mensaje de error
- `executeWithLoading()`: Ejecuta operaciones con loading automático
- `buildWithStates()`: Builder que maneja automáticamente los estados
- `processServerResponse()`: Procesa respuestas del servidor

#### Ejemplo de uso:

```dart
class MyWidget extends StatefulWidget {
  // ...
}

class _MyWidgetState extends State<MyWidget> with UIStateMixin {
  
  Future<void> loadData() async {
    await executeWithLoading(
      _performDataLoad(),
      errorMessage: 'Error al cargar datos',
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildWithStates(
      contentBuilder: () => MyContentWidget(),
      onRetry: loadData,
    );
  }
}
```

## Patrones de Uso

### 1. Para vistas con listas de datos:

```dart
class DeviceListPage extends StatefulWidget {
  // ...
}

class _DeviceListPageState extends State<DeviceListPage> with UIStateMixin {
  List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    await executeWithLoading(_fetchDevices());
  }

  Future<void> _fetchDevices() async {
    final response = await apiService.getDevices();
    final result = ResponseValidator.validateDeviceListResponse(response);
    
    if (result.isSuccess) {
      setState(() {
        devices = result.devices.map((d) => Device.fromJson(d)).toList();
      });
    } else {
      setError(result.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Devices')),
      body: buildWithStates(
        contentBuilder: () => ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) => DeviceCard(devices[index]),
        ),
        onRetry: _loadDevices,
      ),
    );
  }
}
```

### 2. Para formularios:

```dart
class ProfileForm extends StatefulWidget {
  // ...
}

class _ProfileFormState extends State<ProfileForm> with UIStateMixin {
  late ErrorManager errorManager;

  @override
  void initState() {
    super.initState();
    initializeErrorManager({
      'email': null,
      'name': null,
      'phone': null,
    });
  }

  Future<void> _submitForm() async {
    final result = await executeWithLoading(
      _performSubmit(),
      errorMessage: 'Error al guardar perfil',
    );
    
    if (result != null) {
      // Formulario guardado exitosamente
      Navigator.of(context).pop();
    }
  }

  Future<bool> _performSubmit() async {
    final response = await apiService.updateProfile(formData);
    final result = processServerResponse(response);
    return result.isSuccess;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildWithStates(
        contentBuilder: () => Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  errorText: errorManager?.getError('email'),
                ),
              ),
              // ... más campos
              ElevatedButton(
                onPressed: isLoading ? null : _submitForm,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 3. Para controladores:

```dart
class ApiController {
  Future<void> updateData(BuildContext context, Map<String, dynamic> data, Function callback) async {
    final response = await apiService.update(data);
    final result = ResponseValidator.validateResponse(response);
    
    if (result.isSuccess) {
      if (context.mounted) {
        toastSuccess(context, 'Datos actualizados');
      }
      callback(result.data);
    } else {
      if (context.mounted) {
        toastDanger(context, result.errorMessage ?? 'Error al actualizar');
      }
    }
  }
}
```

## Beneficios del Sistema

1. **Consistencia**: Mismo manejo de errores en toda la app
2. **Reutilización**: Componentes que se pueden usar en múltiples vistas
3. **Mantenibilidad**: Lógica centralizada fácil de mantener
4. **Escalabilidad**: Fácil agregar nuevos tipos de validación
5. **Testing**: Componentes fáciles de testear por separado

## Migración de Código Existente

Para migrar código existente:

1. Reemplazar validaciones manuales con `ResponseValidator`
2. Usar `UIStateMixin` en widgets con estados de loading/error
3. Implementar `ErrorManager` en formularios
4. Actualizar controladores para usar el nuevo sistema

## Consideraciones

- Siempre verificar `context.mounted` antes de actualizar UI
- Usar el método adecuado de `ResponseValidator` según el tipo de respuesta
- Personalizar mensajes de error según el contexto de la aplicación
- Mantener consistencia en los nombres de campos de error
