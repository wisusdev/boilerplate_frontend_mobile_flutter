
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/data/models/user_model.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/location.dart';

class UserShow extends StatefulWidget {
  const UserShow({super.key});

  @override
  State<UserShow> createState() => _UserShowState();
}

class _UserShowState extends State<UserShow> {
  UserData? _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_user == null) {
      _user = ModalRoute.of(context)?.settings.arguments as UserData?;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Usuario no encontrado'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
        title: Text(
          Location.of(context)!.trans('user_details'),
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, 'users_edit', arguments: _user);
              if (result == true) {
                Navigator.pop(context, true); // Return to previous screen with refresh signal
              }
            },
            tooltip: Location.of(context)!.trans('edit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con avatar y nombre
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      '${_user!.attributes.firstName[0]}${_user!.attributes.lastName[0]}'.toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_user!.attributes.firstName} ${_user!.attributes.lastName}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@${_user!.attributes.username}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.email, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _user!.attributes.email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Información de cuenta
            _buildInfoSection(
              title: Location.of(context)!.trans('account_information'),
              children: [
                _buildInfoRow(
                  icon: Icons.badge,
                  label: Location.of(context)!.trans('user_id'),
                  value: _user!.id,
                ),
                _buildInfoRow(
                  icon: Icons.person,
                  label: Location.of(context)!.trans('username'),
                  value: _user!.attributes.username,
                ),
                _buildInfoRow(
                  icon: Icons.email,
                  label: Location.of(context)!.trans('email'),
                  value: _user!.attributes.email,
                ),
                _buildInfoRow(
                  icon: Icons.verified_user,
                  label: Location.of(context)!.trans('email_verified'),
                  value: _user!.attributes.emailVerifiedAt != null 
                    ? '${Location.of(context)!.trans('yes')} (${_formatDate(_user!.attributes.emailVerifiedAt!)})'
                    : Location.of(context)!.trans('no'),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Roles asignados
            _buildInfoSection(
              title: Location.of(context)!.trans('assigned_roles'),
              children: [
                if (_user!.relationships.roles.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      Location.of(context)!.trans('no_roles_assigned'),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _user!.relationships.roles.map((role) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.security,
                            size: 16,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            role,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Fechas importantes
            _buildInfoSection(
              title: Location.of(context)!.trans('important_dates'),
              children: [
                _buildInfoRow(
                  icon: Icons.calendar_today,
                  label: Location.of(context)!.trans('created_at'),
                  value: _formatDate(_user!.attributes.createdAt),
                ),
                _buildInfoRow(
                  icon: Icons.update,
                  label: Location.of(context)!.trans('updated_at'),
                  value: _formatDate(_user!.attributes.updatedAt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}