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

            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        const Text('Are you sure you want to delete your account?'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(24),
                                backgroundColor: Colors.red
                            ),
                            child: const Icon(Icons.delete_forever, size: 50, color: Colors.white),
                            onPressed: () {
                                // Delete account
                            },
                        )
                    ],
                ),
            ),
        );
    }
}