import 'package:flutter/material.dart';

class RoleEdit extends StatefulWidget {
  const RoleEdit({super.key});

  @override
  State<RoleEdit> createState() => _RoleEditState();
}

class _RoleEditState extends State<RoleEdit> {
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
