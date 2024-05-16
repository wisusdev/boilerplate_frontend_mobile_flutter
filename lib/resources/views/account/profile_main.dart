import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/helpers/text.dart';
import 'package:todolist_flutter/app/interfaces/local/local_user_info.dart';
import 'package:todolist_flutter/app/services/auth_service.dart';
import 'package:todolist_flutter/config/app.dart';

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
        return SingleChildScrollView(
            child: Column(
                children: [
                    Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Column(
                            children: [
                                Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                        children: [
                                            Container(
                                                height: 100,
                                                width: 100,
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3), borderRadius: BorderRadius.circular(100)),
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(100),
                                                    child: FadeInImage(
                                                        height: 100,
                                                        width: 100,
                                                        image: NetworkImage(userInfo.avatar ?? profileImageDefault),
                                                        placeholder: const AssetImage(profileImageDefault),
                                                        imageErrorBuilder: (context, error, stackTrace) => const Image(image: AssetImage(profileImageDefault), fit: BoxFit.fitWidth),
                                                        fit: BoxFit.fitWidth,
                                                    ),
                                                ),
                                            ),
                                            Expanded(
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
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                    const SizedBox(width: 10),
                                                                    InkWell(
                                                                        onTap: () {
                                                                            Navigator.pushNamed(context, 'home');
                                                                        },
                                                                        child: Container(
                                                                            width: 100,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                                                                gradient: LinearGradient(
                                                                                    begin: Alignment.topCenter,
                                                                                    end: Alignment.bottomCenter,
                                                                                    colors: [
                                                                                        Theme.of(context).colorScheme.primary,
                                                                                        Theme.of(context).colorScheme.secondary,
                                                                                    ],
                                                                                ),
                                                                            ),
                                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                            child: Center(
                                                                                child: Text('Editar', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16)),
                                                                            ),
                                                                        ),
                                                                    )
                                                                ],
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                            ),
                                        ],
                                    ),
                                )
                            ],
                        ),
                    ),
  
                    const SizedBox(height: 20),

                    Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            children: [
                                Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).colorScheme.primaryContainer,
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
                                                route: () {
                                                    Navigator.pushNamed(context, 'profile_edit');
                                                }, 
                                                value: '/profile_edit', 
                                                context: context
                                            ),
                                            buildRow(
                                                icon: Icons.logout, 
                                                text: Location.of(context)!.trans('logout'), 
                                                route: () async {
                                                    if(await _authService.logout()){
                                                        Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
                                                    }
                                                }, 
                                                value: '/logout', 
                                                context: context, 
                                                rightIcon: false
                                            )
                                        ],
                                    ),
                                )
                            ],
                        )
                    )
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