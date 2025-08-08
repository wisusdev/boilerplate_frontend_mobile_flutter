import 'package:flutter/material.dart';

class PermissionIndex extends StatefulWidget {
  const PermissionIndex({super.key});

  @override
  State<PermissionIndex> createState() => _PermissionIndexState();
}

class _PermissionIndexState extends State<PermissionIndex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
        title: Text('Permissions', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Text('Permissions Index Page'),
      ),
    );
  }
}
