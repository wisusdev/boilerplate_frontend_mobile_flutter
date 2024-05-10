import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/helpers/text.dart';
import 'package:todolist_flutter/app/interfaces/local/local_user_info.dart';
import 'package:todolist_flutter/app/services/auth_service.dart';

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
            appBar: AppBar(
                leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
                title: Text(
                    capitalizeText(Location.of(context)!.trans('profile')), 
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary
                    )
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                actions: [
                    PopupMenuButton(
                        icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onPrimary),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                                value: 'logout',
                                child: Text('Logout'),
                            ),

                            const PopupMenuItem(
                                value: 'editAccount',
                                child: Text('Edit Account'),
                            )
                        ],
                        onSelected: (String value) {
                            switch(value){
                                case 'logout':
                                    _authService.logout();
                                    
                                    Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
                                    break;
                                case 'editAccount':
                                    Navigator.of(context).pushNamed('home');
                                    break;
                            }
                        },
                    ),
                ],
            ),
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

    Future<LocalUserInfo> futureUserModel() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String user = prefs.getString('user') ?? '';
        return LocalUserInfo.fromJson(jsonDecode(user));
    }

    profile(LocalUserInfo userInfo){
        return Center(
            child: Column(
                children: [
                    ListTile(
                        title: const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${userInfo.firstName} ${userInfo.lastName}'),
                    ),

                    ListTile(
                        title: const Text('Username', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(userInfo.username),
                    ),
                ],
            ),
        );
    }
}