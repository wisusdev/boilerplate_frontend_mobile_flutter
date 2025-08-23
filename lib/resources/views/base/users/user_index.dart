import 'package:boilerplate_frontend_mobile_flutter/core/helpers/location.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/data/models/user_model.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/http/controllers/user_controller.dart';

class UserIndex extends StatefulWidget {
  const UserIndex({super.key});

  @override
  State<UserIndex> createState() => _UserIndexState();
}

class _UserIndexState extends State<UserIndex> {
  final UserController _userController = UserController();
  List<UserData> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  Future<void> _getUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users = await _userController.userIndex(context);
      if (!mounted) return;
      setState(() {
        _users = users.data;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load users';
      });
    }
  }

  void _onMenuSelected(String value, UserData user) async {
    switch (value) {
      case 'view':
        Navigator.pushNamed(context, 'users_show', arguments: user);
        break;
      case 'edit':
        final result = await Navigator.pushNamed(context, 'users_edit', arguments: user);
        if (result == true) {
          _getUsers(); // Refresh the list if editing was successful
        }
        break;
      case 'delete':
        final confirmed = await _confirmDelete(user);
        if (confirmed) {
          await _deleteUser(user);
        }
        break;
    }
  }

  Future<void> _deleteUser(UserData user) async {
    try {
      await _userController.deleteUser(context, userId: user.id);
      
      if (!mounted) return;
      
      setState(() {
        _users.removeWhere((userItem) => userItem.id == user.id);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario "${user.attributes.firstName} ${user.attributes.lastName}" eliminado exitosamente')),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar usuario: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _confirmDelete(UserData user) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Text('¿Eliminar el usuario "${user.attributes.firstName} ${user.attributes.lastName}"?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Eliminar')),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildUserCard(UserData user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        '${user.attributes.firstName[0]}${user.attributes.lastName[0]}'.toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.attributes.firstName} ${user.attributes.lastName}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '@${user.attributes.username}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            user.attributes.email,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) => _onMenuSelected(value, user),
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(value: 'view', child: Text('Ver')),
                        const PopupMenuItem(value: 'edit', child: Text('Editar')),
                        const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                      ],
                    ),
                  ],
                ),
                if (user.relationships.roles.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: user.relationships.roles.map((role) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        role,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateUser,
        child: const Icon(Icons.add),
        tooltip: Location.of(context)!.trans('create_user'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    } else if (_users.isEmpty) {
      return const Center(child: Text('No hay usuarios disponibles'));
    } else {
      return RefreshIndicator(
        onRefresh: _getUsers,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final user = _users[index];
            return _buildUserCard(user);
          },
        ),
      );
    }
  }

  Future<void> _navigateToCreateUser() async {
    final result = await Navigator.pushNamed(context, 'users_create');
    if (result == true) {
      _getUsers(); // Refresh the list if creation was successful
    }
  }
}
