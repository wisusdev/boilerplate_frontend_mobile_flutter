import 'package:flutter/material.dart';

class ProfileEdit extends StatefulWidget {
    const ProfileEdit({super.key});

    @override
    State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Edit Profile'),
            ),
            body: const Center(
                child: Text('Edit Profile'),
            ),
        );
    }
}