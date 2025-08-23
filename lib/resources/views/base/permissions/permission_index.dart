import 'package:boilerplate_frontend_mobile_flutter/app/data/models/permissions_model.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/http/controllers/permission_controller.dart';
import 'package:flutter/material.dart';

class PermissionIndex extends StatefulWidget {
  const PermissionIndex({super.key});

  @override
  State<PermissionIndex> createState() => _PermissionIndexState();
}

class _PermissionIndexState extends State<PermissionIndex> {

  final PermissionController _permissionController = PermissionController();
  List<PermissionAttribute> _permissions = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getPermissions();
  }

  Future<void> _getPermissions() async {
    _permissionController.permissionIndex(context).then((permissions) {
      setState(() {
        _permissions = permissions.data.attributes;
        _isLoading = false;
        _errorMessage = null;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load permissions';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  _isLoading ? const Center(child: CircularProgressIndicator()) : _errorMessage != null ? Center(child: Text(_errorMessage!)) : ListView.builder(
      itemCount: _permissions.length,
      itemBuilder: (context, index) {
        final permission = _permissions[index];
        return ListTile(
          title: Text(permission.name),
        );
      },
    );
  }
}
