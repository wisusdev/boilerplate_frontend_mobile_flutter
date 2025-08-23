# Sistema de Permisos - Flutter

Este sistema de permisos proporciona una solución completa para controlar el acceso a diferentes funcionalidades de la aplicación basándose en los permisos del usuario autenticado.

## 🚀 Características

- ✅ Validación de permisos granular
- ✅ Widgets reactivos que se muestran/ocultan según permisos
- ✅ Guards para proteger rutas
- ✅ Mixin para fácil integración en cualquier widget
- ✅ Soporte para permisos individuales y grupales
- ✅ Configuración centralizada
- ✅ Tests unitarios incluidos

## 📁 Estructura del Sistema

```
lib/
├── app/services/
│   └── permission_service.dart          # Servicio principal de permisos
├── config/
│   └── permission_config.dart           # Configuración de permisos
├── core/mixins/
│   └── permission_mixin.dart            # Mixin para widgets
└── resources/widgets/permissions/
    ├── permission_widget.dart           # Widget condicional
    ├── permission_floating_action_button.dart
    └── permission_popup_menu.dart       # Menu popup con permisos

test/
└── services/
    └── permission_service_test.dart     # Tests unitarios
```

## 🔧 Instalación y Configuración

### 1. Configurar permisos en el login

El sistema se inicializa automáticamente después del login exitoso:

```dart
// En AuthService.login()
if (loginResponse.statusCode == 200 && responseBody.containsKey('data')) {
  // Guardar permisos en SharedPreferences
  prefs.setString('permissions', json.encode(responseBody['data']['relationships']['permissions']));
  
  // Inicializar servicio de permisos
  await PermissionService.instance.initializePermissions();
}
```

### 2. Estructura de permisos del backend

El backend debe devolver los permisos en el siguiente formato:

```json
{
  "data": {
    "relationships": {
      "permissions": {
        "data": [
          {"id": "1", "attributes": {"name": "users:index"}},
          {"id": "2", "attributes": {"name": "users:create"}},
          {"id": "3", "attributes": {"name": "roles:edit"}}
        ]
      }
    }
  }
}
```

## 🎯 Uso del Sistema

### Verificación Básica de Permisos

```dart
final permissionService = PermissionService.instance;

// Verificar un permiso específico
if (permissionService.hasPermission('users:create')) {
  // Mostrar botón crear
}

// Verificar múltiples permisos (ANY)
if (permissionService.hasAnyPermission(['users:edit', 'users:delete'])) {
  // Mostrar opciones de edición o eliminación
}

// Verificar múltiples permisos (ALL)
if (permissionService.hasAllPermissions(['users:edit', 'admin:access'])) {
  // Mostrar funcionalidad avanzada
}
```

### Usando el Mixin

```dart
class _UserListState extends State<UserList> with PermissionMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (canCreate('users'))
            ElevatedButton(
              onPressed: () => _createUser(),
              child: Text('Crear Usuario'),
            ),
        ],
      ),
    );
  }
}
```

### Widgets de Permisos

#### PermissionWidget - Mostrar/Ocultar contenido

```dart
PermissionWidget(
  requiredPermissions: ['users:edit'],
  child: IconButton(
    icon: Icon(Icons.edit),
    onPressed: () => _editUser(),
  ),
  fallback: Text('Sin permisos'), // Opcional
)
```

#### PermissionFloatingActionButton

```dart
PermissionFloatingActionButton(
  module: 'users',
  action: 'create', // create, edit, delete
  onPressed: () => Navigator.pushNamed(context, 'users_create'),
  tooltip: 'Crear Usuario',
)
```

### Guards para Rutas

```dart
// En api_routes.dart
'users_create': (context) => const AuthGuard(
  child: ModulePermissionGuard(
    module: 'users',
    action: 'create',
    child: UserCreate(),
  ),
),
```

### Configuración del Menú

```dart
const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'users',
    link: 'users_index',
    icon: Icons.people,
    location: MenuLocation.drawer,
    requiredPermissions: ['users:index', 'users:view'],
  ),
];
```

## 📋 Convenciones de Nomenclatura

### Formato de Permisos
- `module:action` (ej: `users:create`, `roles:edit`)

### Acciones Estándar
- `index` - Ver lista
- `view` - Ver elementos
- `show` - Ver detalles
- `create` - Crear nuevos
- `edit` - Editar existentes
- `update` - Actualizar (alias de edit)
- `delete` - Eliminar

### Módulos Principales
- `users` - Gestión de usuarios
- `roles` - Gestión de roles
- `permissions` - Gestión de permisos
- `settings` - Configuraciones
- `reports` - Reportes

## 🔍 Métodos Disponibles

### PermissionService

```dart
// Verificación básica
bool hasPermission(String permission)
bool hasAnyPermission(List<String> permissions)
bool hasAllPermissions(List<String> permissions)

// Verificación por módulo
bool canAccessView(String module)
bool canCreate(String module)
bool canEdit(String module) 
bool canDelete(String module)

// Utilidades
Map<String, bool> getCrudPermissions(String module)
void clearPermissions()
void debugPrintPermissions()
```

### PermissionMixin

```dart
// Todos los métodos de PermissionService +
bool canView(String module)    // index, view, show
bool canShow(String module)    // show específicamente
```

## 🧪 Testing

Ejecutar las pruebas del sistema de permisos:

```bash
flutter test test/services/permission_service_test.dart
```

### Ejemplo de Test

```dart
test('should check permissions correctly', () async {
  final mockPermissions = {
    'data': [
      {'id': '1', 'attributes': {'name': 'users:create'}},
    ]
  };

  await _setupPermissions(mockPermissions);
  
  expect(permissionService.canCreate('users'), true);
  expect(permissionService.canDelete('users'), false);
});
```

## 🚨 Consideraciones de Seguridad

1. **Validación del Backend**: Los permisos del frontend son solo para UX. Siempre validar en el backend.

2. **Actualización de Permisos**: Los permisos se cargan al hacer login. Para cambios en tiempo real, implementar actualización de permisos.

3. **Fallback Seguro**: Por defecto, si no hay permisos, se niega el acceso.

## 🔧 Debugging

Para ver los permisos del usuario actual:

```dart
PermissionService.instance.debugPrintPermissions();
```

## 📈 Extensión

Para agregar nuevos módulos o permisos:

1. Actualizar `PermissionConfig`
2. Agregar permisos al backend
3. Actualizar tests si es necesario

## 🤝 Contribución

Para contribuir al sistema de permisos:

1. Seguir las convenciones de nomenclatura
2. Agregar tests para nuevas funcionalidades
3. Actualizar documentación
4. Mantener compatibilidad hacia atrás
