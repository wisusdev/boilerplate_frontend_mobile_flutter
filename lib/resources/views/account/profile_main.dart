import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/interfaces/local/local_user_info.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/auth_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/app.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/account/profile_edit.dart';

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
                    buildRow(
                        icon: Icons.edit, 
                        text: Location.of(context)!.trans('edit'), 
                        route: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProfileEdit()),
                            );

                            if (result == 'update' && mounted) {
                                setState(() {
                                    futureUserModel();
                                });
                            }
                        }, 
                        value: '/profile_edit', 
                        context: context
                    ),
                    buildRow(
                        icon: Icons.key, 
                        text: 'Change password', 
                        route: (){}, 
                        value: 'change-password', 
                        context: context
                    ),
                    buildRow(
                        icon: Icons.devices, 
                        text: 'Devices', 
                        route: (){}, 
                        value: 'change-password', 
                        context: context
                    ),
                    buildRow(
                        icon: Icons.delete, 
                        text: 'Delete account', 
                        route: (){}, 
                        value: 'change-password', 
                        context: context
                    ),
                    buildRow(
                        icon: Icons.logout, 
                        text: Location.of(context)!.trans('logout'), 
                        route: () async {
                            if(await _authService.logout()){
                                if(mounted) {
                                    Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
                                }
                            }
                        }, 
                        value: '/logout', 
                        context: context, 
                        rightIcon: false
                    ),
                ],
            ),
        );
    }
}

Widget buildRow({required IconData icon, required String text, required void Function()? route, required String value,  required BuildContext context, bool rightIcon = true}) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.primaryContainer, width: 1)),
        ),
        child: InkWell(
            onTap: route,
            child: Row(
                children: [
                    Icon(icon, color: Theme.of(context).colorScheme.primary),
                    Expanded(
                        child: Padding(padding: const EdgeInsets.only(left: 10), child: Text(text, style: const TextStyle(fontSize: 16))),
                    ),
                    rightIcon ? Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary) : Container(),   
                ],
            ),
        ),
    );
}