import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/permission_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/location.dart';

/// Guard que protege widgets basado en permisos del usuario
class PermissionGuard extends StatelessWidget {
  final Widget child;
  final List<String> requiredPermissions;
  final bool requireAll; // Si es true, requiere TODOS los permisos, si es false, requiere AL MENOS UNO
  final Widget? fallback;

  const PermissionGuard({
    super.key,
    required this.child,
    required this.requiredPermissions,
    this.requireAll = false,
    this.fallback,
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
    }

    return fallback ?? _buildAccessDeniedView(context);
  }

  Widget _buildAccessDeniedView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Location.of(context)!.trans('access_denied')),
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.block,
                size: 80,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                Location.of(context)!.trans('access_denied_title'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                Location.of(context)!.trans('access_denied_message'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: Text(Location.of(context)!.trans('go_back')),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Guard específico para módulos CRUD
class ModulePermissionGuard extends StatelessWidget {
  final Widget child;
  final String module; // ej: 'users', 'roles', 'permissions'
  final String action; // ej: 'index', 'create', 'edit', 'delete', 'show'
  final Widget? fallback;

  const ModulePermissionGuard({
    super.key,
    required this.child,
    required this.module,
    this.action = 'index',
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return PermissionGuard(
      requiredPermissions: ['$module:$action', '$module:view'],
      requireAll: false,
      fallback: fallback,
      child: child,
    );
  }
}
