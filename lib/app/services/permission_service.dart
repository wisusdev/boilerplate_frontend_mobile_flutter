import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionService {
  static PermissionService? _instance;
  List<String> userPermissions = [];

  // Singleton pattern
  PermissionService._internal();
  
  static PermissionService get instance {
    _instance ??= PermissionService._internal();
    return _instance!;
  }

  /// Inicializa los permisos del usuario desde SharedPreferences
  Future<void> initializePermissions() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? permissionsJson = prefs.getString('permissions');
    
      if (permissionsJson != null) {
        List<dynamic> permissionsData = json.decode(permissionsJson);
        userPermissions = permissionsData.cast<String>();
      } else {
        userPermissions = [];
      }
    } catch (e) {
      userPermissions = [];
    }
  }

  /// Obtiene todos los permisos del usuario actual
  List<String> getUserPermissions() {
    return List<String>.from(userPermissions);
  }

  /// Verifica si el usuario tiene un permiso específico
  bool hasPermission(String permission) {
    return userPermissions.contains(permission);
  }

  /// Verifica si el usuario tiene alguno de los permisos especificados
  bool hasAnyPermission(List<String> permissions) {
    for (String permission in permissions) {
      if (userPermissions.contains(permission)) {
        return true;
      }
    }
    return false;
  }

  /// Verifica si el usuario tiene todos los permisos especificados
  bool hasAllPermissions(List<String> permissions) {
    for (String permission in permissions) {
      if (!userPermissions.contains(permission)) {
        return false;
      }
    }
    return true;
  }

  /// Verifica si el usuario puede acceder a una vista específica
  bool canAccessView(String viewName) {
    return hasPermission('$viewName:index') || hasPermission('$viewName:view');
  }

  /// Verifica si el usuario puede crear en una vista específica
  bool canCreate(String viewName) {
    return hasPermission('$viewName:create');
  }

  /// Verifica si el usuario puede editar en una vista específica
  bool canEdit(String viewName) {
    return hasPermission('$viewName:edit') || hasPermission('$viewName:update');
  }

  /// Verifica si el usuario puede eliminar en una vista específica
  bool canDelete(String viewName) {
    return hasPermission('$viewName:delete');
  }

  /// Verifica si el usuario puede ver detalles en una vista específica
  bool canShow(String viewName) {
    return hasPermission('$viewName:show') || hasPermission('$viewName:view');
  }

  /// Verifica permisos CRUD completos para una vista
  Map<String, bool> getCrudPermissions(String viewName) {
    return {
      'canAccess': canAccessView(viewName),
      'canCreate': canCreate(viewName),
      'canEdit': canEdit(viewName),
      'canDelete': canDelete(viewName),
      'canShow': canShow(viewName),
    };
  }

  /// Limpia todos los permisos (útil para logout)
  void clearPermissions() {
    userPermissions.clear();
  }

  /// Actualiza los permisos (útil si los permisos cambian durante la sesión)
  Future<void> refreshPermissions() async {
    await initializePermissions();
  }

  /// Verifica si el usuario es administrador (tiene permisos administrativos)
  bool isAdmin() {
    return hasAnyPermission([
      'admin:*',
      'users:*',
      'roles:*',
      'permissions:*',
    ]);
  }

  /// Verifica permisos específicos para módulos principales
  bool canAccessUsers() => canAccessView('users');
  bool canAccessRoles() => canAccessView('roles');
  bool canAccessPermissions() => canAccessView('permissions');
  bool canAccessSettings() => hasPermission('settings:index') || hasPermission('settings:view');
  bool canAccessProfile() => hasPermission('profile:index') || hasPermission('profile:view');
}
