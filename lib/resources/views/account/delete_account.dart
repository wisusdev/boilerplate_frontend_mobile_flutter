import 'package:flutter/material.dart';

class DeleteAccount extends StatefulWidget {
    const DeleteAccount({super.key});

    @override
    State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
                title: Text('Delete Account', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                backgroundColor: Theme.of(context).colorScheme.primary,
            ),

            body: SingleChildScrollView(
                child: Column(
                    children: [
                        Text('Delete Account'),
                    ],
                ),
            ),
        );
    }
}