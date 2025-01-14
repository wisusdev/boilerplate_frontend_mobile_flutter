import 'package:boilerplate_frontend_mobile_flutter/app/http/controllers/account_controller.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/modal_confirm.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/interfaces/response/connected_devices_model.dart';

class ConnectedDevices extends StatefulWidget {
    const ConnectedDevices({super.key});

    @override
    State<ConnectedDevices> createState() => _ConnectedDevicesState();
}

class _ConnectedDevicesState extends State<ConnectedDevices> {
    
    final AccountController _accountController = AccountController();
    List<Datum> _devices = [];

    @override
    void initState() {
        super.initState();
        _fetchDevices();
    }

    Future<void> _fetchDevices() async {
        await _accountController.getDeviceAuthList((data) {
            setState(() {
                _devices = data.map<Datum>((item) => Datum.fromJson(item)).toList();
            });
        });
    }

    void _disconnectDevice(String deviceId) async {
        /*await _accountController.disconnectDevice(deviceId, () {
            setState(() {
                _devices.removeWhere((device) => device.id == deviceId);
            });
        });*/
    }

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
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: _devices.length,
                            itemBuilder: (context, index) {
                                final device = _devices[index];
                                final attributes = device.attributes;
                                return Column(
                                    children: [
                                        ListTile(
                                            title: Text('Browser: ${attributes.browser}'),
                                            subtitle: Text('OS: ${attributes.os}\nIP: ${attributes.ip}\nCountry: ${attributes.country}\nLogin at: ${attributes.loginAt}'),
                                            trailing: IconButton(
                                                icon: const Icon(Icons.logout, color: Colors.red),
                                                onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                            return ModalConfirm(
                                                                title: 'Cerrar sesión',
                                                                content: '¿Estás seguro de que deseas cerrar sesión en este dispositivo?',
                                                                onConfirm: ()  {
                                                                    _disconnectDevice(device.id);
                                                                },
                                                                onCancel: () {
                                                                    Navigator.of(context).pop();
                                                                },
                                                            );
                                                        },
                                                    );
                                                },
                                            ),
                                        ),

                                        const Divider(), // Añadir un separador
                                    ],
                                );
                            },
                        ),
                    ],
                ),
            ),
        );
    }
}