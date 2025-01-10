import 'package:flutter/material.dart';

class ConnectedDevices extends StatefulWidget {
    const ConnectedDevices({super.key});

    @override
    State<ConnectedDevices> createState() => _ConnectedDevicesState();
}

class _ConnectedDevicesState extends State<ConnectedDevices> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
                title: Text('Connected devices', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                backgroundColor: Theme.of(context).colorScheme.primary,
            ),

            body: SingleChildScrollView(
                child: Column(
                    children: [
                        Text('Connected devices'),
                    ],
                ),
            ),
        );
    }
}