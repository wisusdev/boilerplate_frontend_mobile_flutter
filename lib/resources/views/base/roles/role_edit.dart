import 'package:boilerplate_frontend_mobile_flutter/app/data/models/role_model.dart';
import 'package:flutter/material.dart';

class RoleEdit extends StatefulWidget {

  final RoleData role;
  const RoleEdit({super.key, required this.role});

  @override
  State<RoleEdit> createState() => _RoleEditState();
}

class _RoleEditState extends State<RoleEdit> {
  @override
  void initState() {
    super.initState();
    //print('Editing role: ${widget.role.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
        title: Text('Role Edit', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Text('Role Edit Page', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
      ),
    );
  }
}
