import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/permission_service.dart';

class PermissionPopupMenuItem<T> extends PopupMenuItem<T> {
  final List<String> requiredPermissions;
  final bool requireAll;

  const PermissionPopupMenuItem({
    super.key,
    required this.requiredPermissions,
    this.requireAll = false,
    required super.value,
    required super.child,
    super.onTap,
    super.enabled = true,
  });

  bool get hasPermission {
    final permissionService = PermissionService.instance;
    
    if (requireAll) {
      return permissionService.hasAllPermissions(requiredPermissions);
    } else {
      return permissionService.hasAnyPermission(requiredPermissions);
    }
  }
}

class PermissionPopupMenuButton<T> extends StatelessWidget {
  final String module;
  final PopupMenuItemSelected<T>? onSelected;
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final Widget? child;
  final Widget? icon;
  final String? tooltip;

  const PermissionPopupMenuButton({
    super.key,
    required this.module,
    this.onSelected,
    required this.itemBuilder,
    this.child,
    this.icon,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final permissionService = PermissionService.instance;
    
    // Verificar si tiene permisos para al menos una acción del módulo
    if (!permissionService.canAccessView(module)) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<T>(
      onSelected: onSelected,
      itemBuilder: (context) {
        final items = itemBuilder(context);
        // Filtrar items que requieren permisos
        return items.where((item) {
          if (item is PermissionPopupMenuItem<T>) {
            return item.hasPermission;
          }
          return true; // Mostrar items normales sin restricciones
        }).toList();
      },
      child: child,
      icon: icon,
      tooltip: tooltip,
    );
  }
}
