import 'package:boilerplate_frontend_mobile_flutter/app/services/permission_service.dart';

mixin PermissionMixin {
  final PermissionService _permissionService = PermissionService.instance;

  /// Verifica si el usuario tiene un permiso específico
  bool hasPermission(String permission) {
    return _permissionService.hasPermission(permission);
  }

  /// Verifica si el usuario tiene alguno de los permisos especificados
  bool hasAnyPermission(List<String> permissions) {
    return _permissionService.hasAnyPermission(permissions);
  }

  /// Verifica si el usuario tiene todos los permisos especificados
  bool hasAllPermissions(List<String> permissions) {
    return _permissionService.hasAllPermissions(permissions);
  }

  /// Verifica si puede acceder a un módulo
  bool canAccessView(String module) {
    return _permissionService.canAccessView(module);
  }

  /// Verifica si puede ver/mostrar un recurso
  bool canView(String module) {
    return hasAnyPermission(['$module:index', '$module:view', '$module:show']);
  }

  /// Verifica si puede mostrar detalles de un recurso
  bool canShow(String module) {
    return hasPermission('$module:show');
  }

  /// Verifica si puede crear un recurso
  bool canCreate(String module) {
    return _permissionService.canCreate(module);
  }

  /// Verifica si puede editar un recurso
  bool canEdit(String module) {
    return _permissionService.canEdit(module);
  }

  /// Verifica si puede eliminar un recurso
  bool canDelete(String module) {
    return _permissionService.canDelete(module);
  }

  /// Obtiene todos los permisos CRUD para un módulo
  Map<String, bool> getCrudPermissions(String module) {
    return _permissionService.getCrudPermissions(module);
  }
}
