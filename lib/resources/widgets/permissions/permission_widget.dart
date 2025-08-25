import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/permission_service.dart';

class PermissionWidget extends StatelessWidget {
  final List<String> requiredPermissions;
  final Widget child;
  final Widget? fallback;
  final bool requireAll;

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
    
    bool hasAccess;
    if (requireAll) {
      hasAccess = permissionService.hasAllPermissions(requiredPermissions);
    } else {
      hasAccess = permissionService.hasAnyPermission(requiredPermissions);
    }

    if (hasAccess) {
      return child;
    } else {
      return fallback ?? const SizedBox.shrink();
    }
  }
}
