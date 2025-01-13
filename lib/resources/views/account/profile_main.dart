import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/interfaces/local/local_user_info.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/auth_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/app.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/account/profile_edit.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/modal_confirm.dart';

class ProfileMain extends StatefulWidget {
    const ProfileMain({Key? key}) : super(key: key);

    @override
    State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
    final AuthService _authService = AuthService();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: _buildAppBar(context),
            body: FutureBuilder(
                future: futureUserModel(),
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                    } else {
                        return profile(snapshot.data as LocalUserInfo);
                    }
                },
            ),
        );
    }

    AppBar _buildAppBar(BuildContext context) {
        return AppBar(
            leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
            title: Text(
                capitalizeText(Location.of(context)!.trans('profile')), 
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
        );
    }

    Future<LocalUserInfo> futureUserModel() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String user = prefs.getString('user') ?? '';
        return LocalUserInfo.fromJson(jsonDecode(user));
    }

    Widget profile(LocalUserInfo userInfo) {
        return SingleChildScrollView(
            child: Column(
                children: [
                    _buildProfileHeader(context, userInfo),
                    const SizedBox(height: 20),
                    _buildProfileOptions(context, userInfo),
                ],
            ),
        );
    }

    Widget _buildProfileHeader(BuildContext context, LocalUserInfo userInfo) {
        return Container(
            color: Theme.of(context).colorScheme.onSecondary,
            child: Column(
                children: [
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                            children: [
                                _buildAvatar(context, userInfo),
                                _buildUserInfo(context, userInfo),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildAvatar(BuildContext context, LocalUserInfo userInfo) {
        return Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
                borderRadius: BorderRadius.circular(100),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FadeInImage(
                    height: 100,
                    width: 100,
                    image: userInfo.avatar != null ? NetworkImage(userInfo.avatar) as ImageProvider<Object> : const AssetImage(profileImageDefault),
                    placeholder: const AssetImage(profileImageDefault),
                    imageErrorBuilder: (context, error, stackTrace) => const Image(image: AssetImage(profileImageDefault), fit: BoxFit.fitWidth),
                    fit: BoxFit.fitWidth,
                ),
            ),
        );
    }

    Widget _buildUserInfo(BuildContext context, LocalUserInfo userInfo) {
        return Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                    children: [
                        Row(
                            children: [
                                Text('${userInfo.firstName} ${userInfo.lastName}', overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21.0)),
                            ],
                        ),
                        Row(
                            children: [
                                Text(userInfo.username, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18.0)),
                            ],
                        ),
                    ],
                ),
            ),
        );
    }

    Widget _buildProfileOptions(BuildContext context, LocalUserInfo userInfo) {
        return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
                children: [
                    _buildOptionCard(context, userInfo),
                ],
            ),
        );
    }

    Widget _buildOptionCard(BuildContext context, LocalUserInfo userInfo) {
        return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.onSecondary,
                boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        offset: const Offset(0, 1),
                        blurRadius: 3,
                    ),
                ],
            ),
            child: Column(
                children: [

                    ListTile(
                        leading: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                        title: const Text('Edit', style: TextStyle(fontSize: 16)),
                        subtitle: const Text('Edit your profile', style: TextStyle(fontSize: 14)),
                        onTap: () async {
                            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileEdit()));

                            if (result == 'update' && mounted) {
                                setState(() {
                                    futureUserModel();
                                });
                            }
                        },
                        trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
                    ),

                    ListTile(
                        leading: Icon(Icons.key, color: Theme.of(context).colorScheme.primary),
                        title: const Text('Change Password', style: TextStyle(fontSize: 16)),
                        subtitle: const Text('Change your password', style: TextStyle(fontSize: 14)),
                        onTap: () => Navigator.pushNamed(context, 'change_password'),
                        trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
                    ),

                    ListTile(
                        leading: Icon(Icons.devices, color: Theme.of(context).colorScheme.primary),
                        title: const Text('Devices', style: TextStyle(fontSize: 16)),
                        subtitle: const Text('Connected devices', style: TextStyle(fontSize: 14)),
                        onTap: () => Navigator.pushNamed(context, 'connected_devices'),
                        trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
                    ),

                    ListTile(
                        leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                        title: const Text('Delete account', style: TextStyle(fontSize: 16)),
                        subtitle: const Text('Delete your account', style: TextStyle(fontSize: 14)),
                        onTap: () {
                            print('Delete account');
                        },
                        trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
                    ),

                    ListTile(
                        leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
                        title: Text(Location.of(context)!.trans('logout'), style: const TextStyle(fontSize: 16)),
                        subtitle: const Text('Logout from the app', style: TextStyle(fontSize: 14)),
                        onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                    return ModalConfirm(
                                        title: 'Cerrar sesión',
                                        content: '¿Estás seguro de que deseas cerrar sesión?',
                                        onConfirm: () async {
                                            if (await _authService.logout()) {
                                                if (mounted) {
                                                    Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
                                                }
                                            }
                                        },
                                        onCancel: () {
                                            Navigator.of(context).pop();
                                        },
                                    );
                                },
                            );
                        },
                    )
                ],
            ),
        );
    }
}