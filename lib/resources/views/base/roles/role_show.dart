import 'package:flutter/material.dart';

class RoleShow extends StatefulWidget {
  const RoleShow({super.key});

  @override
  State<RoleShow> createState() => _RoleShowState();
}

class _RoleShowState extends State<RoleShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
        title: Text('Role Details', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Text('Role Details Page'),
      ),
    );
  }
}