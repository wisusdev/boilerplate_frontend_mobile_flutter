# Sistema de Permisos - Documentación

Este sistema de permisos permite controlar el acceso a diferentes funcionalidades de la aplicación basándose en los permisos del usuario autenticado.

## Componentes Principales

### 1. PermissionService
Servicio singleton que maneja todos los permisos del usuario.

#### Métodos principales:
- `hasPermission(String permission)` - Verifica un permiso específico
- `hasAnyPermission(List<String> permissions)` - Verifica si tiene alguno de los permisos
- `hasAllPermissions(List<String> permissions)` - Verifica que tenga todos los permisos
- `canAccessView(String module)` - Verifica acceso a un módulo
- `canCreate(String module)` - Verifica permisos de creación
- `canEdit(String module)` - Verifica permisos de edición
- `canDelete(String module)` - Verifica permisos de eliminación

### 2. Widgets de Permisos

#### PermissionWidget
```dart
PermissionWidget(
  requiredPermissions: ['users:index', 'users:view'],
  child: Text('Contenido solo para usuarios con permisos'),
  fallback: Text('Sin permisos'), // Opcional
)
```

#### PermissionFloatingActionButton
```dart
PermissionFloatingActionButton(
  module: 'users',
  onPressed: () => Navigator.pushNamed(context, 'users_create'),
  tooltip: 'Crear Usuario',
)
```

#### PermissionPopupMenuButton
```dart
PermissionPopupMenuButton<String>(
  module: 'users',
  onSelected: (value) => _handleAction(value),
  items: [
    PermissionPopupMenuItem(
      value: 'edit',
      child: Text('Editar'),
      requiredPermissions: ['users:edit'],
    ),
    PermissionPopupMenuItem(
      value: 'delete',
      child: Text('Eliminar'),
      requiredPermissions: ['users:delete'],
    ),
  ],
)
```

### 3. Guards de Permisos

#### PermissionGuard
```dart
PermissionGuard(
  requiredPermissions: ['admin:access'],
  child: AdminPanel(),
)
```

#### ModulePermissionGuard
```dart
ModulePermissionGuard(
  module: 'users',
  action: 'create',
  child: UserCreateView(),
)
```

### 4. Mixin para Vistas

```dart
class _UserIndexState extends State<UserIndex> with PermissionMixin {
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

## Configuración del Menú

El sistema filtra automáticamente los elementos del menú basándose en permisos:

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

## Convenciones de Nomenclatura

### Formato de Permisos
- `module:action` (ej: `users:create`, `roles:edit`)
- Acciones comunes: `index`, `view`, `show`, `create`, `edit`, `update`, `delete`

### Módulos Principales
- `users` - Gestión de usuarios
- `roles` - Gestión de roles
- `permissions` - Gestión de permisos
- `profile` - Perfil de usuario
- `settings` - Configuraciones

## Ejemplos de Uso

### 1. En una Vista de Lista
```dart
class _UserIndexState extends State<UserIndex> with PermissionMixin {
  Widget _buildUserCard(UserData user) {
    return Card(
      child: ListTile(
        title: Text(user.name),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleAction(value, user),
          itemBuilder: (context) => [
            if (canShow('users'))
              const PopupMenuItem(value: 'view', child: Text('Ver')),
            if (canEdit('users'))
              const PopupMenuItem(value: 'edit', child: Text('Editar')),
            if (canDelete('users'))
              const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
          ],
        ),
      ),
    );
  }
}
```

### 2. En Rutas Protegidas
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

### 3. Verificación Condicional
```dart
final permissions = getCrudPermissions('users');

if (permissions['canCreate']!) {
  // Mostrar botón de crear
}

if (permissions['canEdit']!) {
  // Mostrar opción de editar
}
```

## Inicialización

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

## Debugging

Para ver los permisos del usuario actual:
```dart
PermissionService.instance.debugPrintPermissions();
```
