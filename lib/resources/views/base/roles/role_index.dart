import 'package:boilerplate_frontend_mobile_flutter/core/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/text.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/data/models/role_model.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/http/controllers/role_controller.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/permission_widget.dart';

class RoleIndex extends StatefulWidget {
  const RoleIndex({super.key});

  @override
  State<RoleIndex> createState() => _RoleIndexState();
}

class _RoleIndexState extends State<RoleIndex> with PermissionMixin {
  final RoleController _roleController = RoleController();
  List<RoleData> _roles = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getRoles();
  }

  Future<void> _getRoles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final roles = await _roleController.roleIndex(context);
      if (!mounted) return;
      setState(() {
        _roles = roles.data;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load roles';
      });
    }
  }

  void _onMenuSelected(String value, RoleData role) async {
    switch (value) {
      case 'view':
        _showRoleDetails(role);
        break;
      case 'edit':
        // Navegar a pantalla de edición y esperar resultado
        final result = await Navigator.pushNamed(context, 'roles_edit', arguments: role);
        if (result == true) {
          _getRoles(); // Refresh the list if editing was successful
        }
        break;
      case 'delete':
        final confirmed = await _confirmDelete(role);
        if (confirmed) {
          await _deleteRole(role);
        }
        break;
    }
  }

  Future<void> _deleteRole(RoleData role) async {
    try {
      await _roleController.deleteRole(context, roleId: role.id);

      if (!mounted) {
        return;
      }

      setState(() {
        _roles.removeWhere((roleItem) => roleItem.id == role.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rol "${role.name}" eliminado exitosamente')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar rol: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _confirmDelete(RoleData role) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Text('¿Eliminar el rol "${role.name}"?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Eliminar')),
            ],
          ),
        ) ??
        false;
  }

  void _showRoleDetails(RoleData role) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Role details',
      barrierColor: Colors.black54,
      // fondo semitransparente como Bootstrap
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, anim1, anim2) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              minWidth: 280,
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary, // normalmente blanco
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header (similar a modal-header de Bootstrap)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              role.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          // Botón de cerrar estilo Bootstrap (cruz)
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Body (similar a modal-body)
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Permisos', style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: role.permissions
                                  .map((p) => Chip(
                                        label: Text(p.name),
                                        backgroundColor: Colors.blue.shade50,
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    // Footer (similar a modal-footer)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOut);
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    );
  }

  Widget _buildRoleCard(RoleData role) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header con fondo y margen interior
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${role.name} (${role.permissions.length} ${toLowerCaseText(Location.of(context)!.trans('permissions'))})",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                // Tres puntos verticales -> Popup menu
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) => _onMenuSelected(value, role),
                  itemBuilder: (ctx) => [
                    if (canShow('roles'))
                      const PopupMenuItem(value: 'view', child: Text('Ver')),
                    if (canEdit('roles'))
                      const PopupMenuItem(value: 'edit', child: Text('Editar')),
                    if (canDelete('roles'))
                      const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _buildBody(),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: canCreate('roles')
              ? FloatingActionButton(
                  onPressed: _navigateToCreateRole,
                  child: const Icon(Icons.add),
                  tooltip: Location.of(context)!.trans('create_role'),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    } else if (_roles.isEmpty) {
      return const Center(child: Text('No hay roles disponibles'));
    } else {
      return RefreshIndicator(
        onRefresh: _getRoles,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: _roles.length,
          itemBuilder: (context, index) {
            final role = _roles[index];
            return _buildRoleCard(role);
          },
        ),
      );
    }
  }

  Future<void> _navigateToCreateRole() async {
    final result = await Navigator.pushNamed(context, 'roles_create');
    if (result == true) {
      _getRoles(); // Refresh the list if creation was successful
    }
  }
}
