/// Configuración de permisos de la aplicación
/// Define todos los permisos disponibles organizados por módulos
class PermissionConfig {
  // Acciones estándar disponibles
  static const String index = 'index';
  static const String view = 'view';
  static const String show = 'show';
  static const String create = 'create';
  static const String edit = 'edit';
  static const String update = 'update';
  static const String delete = 'delete';
  static const String access = 'access';
  static const String export = 'export';

  // Módulos de la aplicación
  static const String users = 'users';
  static const String roles = 'roles';
  static const String permissions = 'permissions';
  static const String settings = 'settings';
  static const String reports = 'reports';
  static const String profile = 'profile';

  /// Permisos de usuarios
  static const userIndex = '$users:$index';
  static const userView = '$users:$view';
  static const userShow = '$users:$show';
  static const userCreate = '$users:$create';
  static const userEdit = '$users:$edit';
  static const userUpdate = '$users:$update';
  static const userDelete = '$users:$delete';

  /// Permisos de roles
  static const roleIndex = '$roles:$index';
  static const roleView = '$roles:$view';
  static const roleShow = '$roles:$show';
  static const roleCreate = '$roles:$create';
  static const roleEdit = '$roles:$edit';
  static const roleUpdate = '$roles:$update';
  static const roleDelete = '$roles:$delete';

  /// Permisos de configuraciones
  static const settingsAccess = '$settings:$access';

  /// Permisos de reportes
  static const reportsView = '$reports:$view';
  static const reportsExport = '$reports:$export';

  /// Permisos de perfil
  static const profileView = '$profile:$view';
  static const profileEdit = '$profile:$edit';

  /// Lista de todos los permisos disponibles
  static const List<String> allPermissions = [
    // Usuarios
    userIndex,
    userView,
    userShow,
    userCreate,
    userEdit,
    userUpdate,
    userDelete,
    
    // Roles
    roleIndex,
    roleView,
    roleShow,
    roleCreate,
    roleEdit,
    roleUpdate,
    roleDelete,
    
    // Configuraciones
    settingsAccess,
    
    // Reportes
    reportsView,
    reportsExport,
    
    // Perfil
    profileView,
    profileEdit,
  ];

  /// Permisos agrupados por módulo
  static const Map<String, List<String>> permissionsByModule = {
    users: [
      userIndex,
      userView,
      userShow,
      userCreate,
      userEdit,
      userUpdate,
      userDelete,
    ],
    roles: [
      roleIndex,
      roleView,
      roleShow,
      roleCreate,
      roleEdit,
      roleUpdate,
      roleDelete,
    ],
    settings: [
      settingsAccess,
    ],
    reports: [
      reportsView,
      reportsExport,
    ],
    profile: [
      profileView,
      profileEdit,
    ],
  };

  /// Descripción de permisos para UI
  static const Map<String, String> permissionDescriptions = {
    userIndex: 'Ver lista de usuarios',
    userView: 'Ver usuarios',
    userShow: 'Ver detalles de usuario',
    userCreate: 'Crear usuarios',
    userEdit: 'Editar usuarios',
    userUpdate: 'Actualizar usuarios',
    userDelete: 'Eliminar usuarios',
    
    roleIndex: 'Ver lista de roles',
    roleView: 'Ver roles',
    roleShow: 'Ver detalles de rol',
    roleCreate: 'Crear roles',
    roleEdit: 'Editar roles',
    roleUpdate: 'Actualizar roles',
    roleDelete: 'Eliminar roles',
    
    settingsAccess: 'Acceder a configuraciones',
    
    reportsView: 'Ver reportes',
    reportsExport: 'Exportar reportes',
    
    profileView: 'Ver perfil',
    profileEdit: 'Editar perfil',
  };

  /// Obtener permisos por módulo
  static List<String> getModulePermissions(String module) {
    return permissionsByModule[module] ?? [];
  }

  /// Obtener descripción de un permiso
  static String getPermissionDescription(String permission) {
    return permissionDescriptions[permission] ?? permission;
  }

  /// Verificar si un permiso existe
  static bool isValidPermission(String permission) {
    return allPermissions.contains(permission);
  }
}
