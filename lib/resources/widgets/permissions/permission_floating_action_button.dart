import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/permission_service.dart';

class PermissionFloatingActionButton extends StatelessWidget {
  final String module;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Widget? child;
  final String action;

  const PermissionFloatingActionButton({
    super.key,
    required this.module,
    this.onPressed,
    this.tooltip,
    this.child,
    this.action = 'create',
  });

  @override
  Widget build(BuildContext context) {
    final permissionService = PermissionService.instance;
    
    bool hasPermission;
    switch (action) {
      case 'create':
        hasPermission = permissionService.canCreate(module);
        break;
      case 'edit':
        hasPermission = permissionService.canEdit(module);
        break;
      case 'delete':
        hasPermission = permissionService.canDelete(module);
        break;
      default:
        hasPermission = permissionService.canAccessView(module);
    }

    if (!hasPermission) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      child: child ?? const Icon(Icons.add),
    );
  }
}
