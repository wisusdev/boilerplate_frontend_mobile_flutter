import 'package:flutter/material.dart';

class RoleCreate extends StatefulWidget {
  const RoleCreate({super.key});

  @override
  State<RoleCreate> createState() => _RoleCreateState();
}

class _RoleCreateState extends State<RoleCreate> {
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
