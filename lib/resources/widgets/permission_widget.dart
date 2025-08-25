import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/permission_service.dart';

/// Widget que condiciona la visualización de su hijo basado en permisos
class PermissionWidget extends StatelessWidget {
  final List<String> requiredPermissions;
  final Widget child;
  final Widget? fallback;
  final bool requireAll; // Si es true, requiere TODOS los permisos, si es false, requiere AL MENOS UNO

  const PermissionWidget({
    super.key,
    required this.requiredPermissions,
    required this.child,
    this.fallback,
    this.requireAll = false,
  });

  @override
  Widget build(BuildContext context) {
    final permissionService = PermissionService.instance;
    bool hasPermission;

    if (requireAll) {
      hasPermission = permissionService.hasAllPermissions(requiredPermissions);
    } else {
      hasPermission = permissionService.hasAnyPermission(requiredPermissions);
    }

    if (hasPermission) {
      return child;
    } else {
      return fallback ?? const SizedBox.shrink();
    }
  }
}

/// Widget que oculta el FloatingActionButton si no tiene permisos de creación
class PermissionFloatingActionButton extends StatelessWidget {
  final String module; // ej: 'users', 'roles', etc.
  final VoidCallback onPressed;
  final Widget? child;
  final String? tooltip;

  const PermissionFloatingActionButton({
    super.key,
    required this.module,
    required this.onPressed,
    this.child,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return PermissionWidget(
      requiredPermissions: ['$module:create'],
      child: FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip,
        child: child ?? const Icon(Icons.add),
      ),
    );
  }
}

/// Widget que condiciona botones de acción (editar, eliminar, etc.)
class PermissionActionButton extends StatelessWidget {
  final String action; // 'edit', 'delete', 'show', etc.
  final String module; // 'users', 'roles', etc.
  final VoidCallback onPressed;
  final Widget child;

  const PermissionActionButton({
    super.key,
    required this.action,
    required this.module,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PermissionWidget(
      requiredPermissions: ['$module:$action'],
      child: child,
    );
  }
}

/// PopupMenuButton que filtra opciones basado en permisos
class PermissionPopupMenuButton<T> extends StatelessWidget {
  final String module;
  final Function(T) onSelected;
  final Widget? icon;
  final List<PermissionPopupMenuItem<T>> items;

  const PermissionPopupMenuButton({
    super.key,
    required this.module,
    required this.onSelected,
    required this.items,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final permissionService = PermissionService.instance;
    
    // Filtrar elementos basado en permisos
    final filteredItems = items.where((item) {
      if (item.requiredPermissions.isEmpty) return true;
      return permissionService.hasAnyPermission(item.requiredPermissions);
    }).map((item) => PopupMenuItem<T>(
      value: item.value,
      child: item.child,
    )).toList();

    // Si no hay elementos después del filtrado, no mostrar el botón
    if (filteredItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<T>(
      icon: icon,
      onSelected: onSelected,
      itemBuilder: (context) => filteredItems,
    );
  }
}

/// Elemento de PopupMenu con permisos
class PermissionPopupMenuItem<T> {
  final T value;
  final Widget child;
  final List<String> requiredPermissions;

  const PermissionPopupMenuItem({
    required this.value,
    required this.child,
    this.requiredPermissions = const [],
  });
}

/// Mixin para facilitar la verificación de permisos en las vistas
mixin PermissionMixin {
  PermissionService get permissionService => PermissionService.instance;

  bool hasPermission(String permission) => permissionService.hasPermission(permission);
  bool hasAnyPermission(List<String> permissions) => permissionService.hasAnyPermission(permissions);
  bool hasAllPermissions(List<String> permissions) => permissionService.hasAllPermissions(permissions);

  bool canAccess(String module) => permissionService.canAccessView(module);
  bool canCreate(String module) => permissionService.canCreate(module);
  bool canEdit(String module) => permissionService.canEdit(module);
  bool canDelete(String module) => permissionService.canDelete(module);
  bool canShow(String module) => permissionService.canShow(module);

  Map<String, bool> getCrudPermissions(String module) => permissionService.getCrudPermissions(module);
}
