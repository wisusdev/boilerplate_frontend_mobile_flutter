import 'package:boilerplate_frontend_mobile_flutter/app/data/models/role_model.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/data/models/permissions_model.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/http/controllers/permission_controller.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/http/controllers/role_controller.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/location.dart';

class RoleEdit extends StatefulWidget {
  final RoleData role;
  const RoleEdit({super.key, required this.role});

  @override
  State<RoleEdit> createState() => _RoleEditState();
}

class _RoleEditState extends State<RoleEdit> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final RoleController _roleController = RoleController();
  final PermissionController _permissionController = PermissionController();
  
  List<PermissionAttribute> _availablePermissions = [];
  List<String> _selectedPermissions = [];
  bool _isLoadingPermissions = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.role.name;
    _selectedPermissions = widget.role.permissions.map((p) => p.name).toList();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    setState(() {
      _isLoadingPermissions = true;
      _errorMessage = null;
    });

    try {
      final permissionsModel = await _permissionController.permissionIndex(context);
      if (!mounted) return;
      setState(() {
        _availablePermissions = permissionsModel.data.attributes;
        _isLoadingPermissions = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingPermissions = false;
        _errorMessage = 'Error al cargar permisos: $e';
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await _roleController.updateRole(
        context,
        roleId: widget.role.id,
        name: _nameController.text.trim(),
        permissions: _selectedPermissions,
      );

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Location.of(context)!.trans('role_updated_successfully'))),
      );
      
      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Error al actualizar rol: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
        title: Text(
          Location.of(context)!.trans('edit_role'),
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoadingPermissions
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          border: Border.all(color: Colors.red.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    
                    // Campo de nombre
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: Location.of(context)!.trans('name'),
                        border: const OutlineInputBorder(),
                        enabled: !_isSubmitting,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Location.of(context)!.trans('name_required');
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Sección de permisos
                    Text(
                      Location.of(context)!.trans('permissions'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    
                    if (_availablePermissions.isEmpty)
                      Text(
                        Location.of(context)!.trans('no_permissions_available'),
                        style: TextStyle(color: Colors.grey.shade600),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            // Select/Deselect all
                            CheckboxListTile(
                              title: Text(
                                Location.of(context)!.trans('select_all'),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              value: _selectedPermissions.length == _availablePermissions.length,
                              onChanged: _isSubmitting ? null : (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedPermissions = _availablePermissions.map((p) => p.name).toList();
                                  } else {
                                    _selectedPermissions.clear();
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            const Divider(height: 1),
                            // Individual permissions
                            ...(_availablePermissions.map((permission) => CheckboxListTile(
                              title: Text(permission.name),
                              value: _selectedPermissions.contains(permission.name),
                              onChanged: _isSubmitting ? null : (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedPermissions.add(permission.name);
                                  } else {
                                    _selectedPermissions.remove(permission.name);
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ))),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Botones de acción
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                            child: Text(Location.of(context)!.trans('cancel')),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitForm,
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(Location.of(context)!.trans('update')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
