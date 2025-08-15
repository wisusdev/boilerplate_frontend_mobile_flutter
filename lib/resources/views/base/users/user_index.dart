import 'package:flutter/material.dart';

class UserIndex extends StatefulWidget {
  const UserIndex({super.key});

  @override
  State<UserIndex> createState() => _UserIndexState();
}

class _UserIndexState extends State<UserIndex> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('User Index Page'),
    );
  }
}
