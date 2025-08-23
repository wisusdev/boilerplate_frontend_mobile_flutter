
import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/data/models/role_model.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/http/controllers/role_controller.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/http/controllers/user_controller.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/location.dart';

class UserCreate extends StatefulWidget {
  const UserCreate({super.key});

  @override
  State<UserCreate> createState() => _UserCreateState();
}

class _UserCreateState extends State<UserCreate> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  
  final UserController _userController = UserController();
  final RoleController _roleController = RoleController();
  
  List<RoleData> _availableRoles = [];
  List<String> _selectedRoles = [];
  bool _isLoadingRoles = false;
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    setState(() {
      _isLoadingRoles = true;
      _errorMessage = null;
    });

    try {
      final rolesModel = await _roleController.roleIndex(context);
      if (!mounted) return;
      setState(() {
        _availableRoles = rolesModel.data;
        _isLoadingRoles = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingRoles = false;
        _errorMessage = 'Error al cargar roles: $e';
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
      await _userController.createUser(
        context,
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmationController.text,
        roles: _selectedRoles,
      );

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Location.of(context)!.trans('user_created_successfully'))),
      );
      
      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Error al crear usuario: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
        title: Text(
          Location.of(context)!.trans('create_user'),
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoadingRoles
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
                    
                    // Campo de nombre de usuario
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: Location.of(context)!.trans('username'),
                        border: const OutlineInputBorder(),
                        enabled: !_isSubmitting,
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Location.of(context)!.trans('username_required');
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Campos de nombre y apellido en fila
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: Location.of(context)!.trans('first_name'),
                              border: const OutlineInputBorder(),
                              enabled: !_isSubmitting,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return Location.of(context)!.trans('first_name_required');
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: Location.of(context)!.trans('last_name'),
                              border: const OutlineInputBorder(),
                              enabled: !_isSubmitting,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return Location.of(context)!.trans('last_name_required');
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Campo de email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: Location.of(context)!.trans('email'),
                        border: const OutlineInputBorder(),
                        enabled: !_isSubmitting,
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return Location.of(context)!.trans('email_required');
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return Location.of(context)!.trans('email_invalid');
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Campo de contraseña
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: Location.of(context)!.trans('password'),
                        border: const OutlineInputBorder(),
                        enabled: !_isSubmitting,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Location.of(context)!.trans('password_required');
                        }
                        if (value.length < 8) {
                          return Location.of(context)!.trans('password_min_length');
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Campo de confirmación de contraseña
                    TextFormField(
                      controller: _passwordConfirmationController,
                      decoration: InputDecoration(
                        labelText: Location.of(context)!.trans('password_confirmation'),
                        border: const OutlineInputBorder(),
                        enabled: !_isSubmitting,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePasswordConfirmation ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePasswordConfirmation = !_obscurePasswordConfirmation;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePasswordConfirmation,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Location.of(context)!.trans('password_confirmation_required');
                        }
                        if (value != _passwordController.text) {
                          return Location.of(context)!.trans('passwords_do_not_match');
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Sección de roles
                    Text(
                      Location.of(context)!.trans('roles'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    
                    if (_availableRoles.isEmpty)
                      Text(
                        Location.of(context)!.trans('no_roles_available'),
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
                              value: _selectedRoles.length == _availableRoles.length,
                              onChanged: _isSubmitting ? null : (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedRoles = _availableRoles.map((r) => r.name).toList();
                                  } else {
                                    _selectedRoles.clear();
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            const Divider(height: 1),
                            // Individual roles
                            ...(_availableRoles.map((role) => CheckboxListTile(
                              title: Text(role.name),
                              subtitle: Text('${role.permissions.length} permisos'),
                              value: _selectedRoles.contains(role.name),
                              onChanged: _isSubmitting ? null : (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedRoles.add(role.name);
                                  } else {
                                    _selectedRoles.remove(role.name);
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
                                : Text(Location.of(context)!.trans('create')),
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
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }
}