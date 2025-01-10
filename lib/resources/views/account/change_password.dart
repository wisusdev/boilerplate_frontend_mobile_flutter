import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
    const ChangePassword({super.key});

    @override
    State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
                title: Text('Change Password', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                backgroundColor: Theme.of(context).colorScheme.primary,
            ),

            body: SingleChildScrollView(
                child: Column(
                    children: [
                        Text('Change Password'),
                    ],
                ),
            ),
        );
    }
}