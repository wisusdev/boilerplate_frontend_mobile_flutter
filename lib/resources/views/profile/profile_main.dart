import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/helpers/text.dart';
import 'package:todolist_flutter/app/models/user_model.dart';
import 'package:todolist_flutter/app/services/auth_service.dart';
import 'package:todolist_flutter/app/services/user_service.dart';

class ProfileMain extends StatefulWidget {
    const ProfileMain({Key? key}) : super(key: key);

    @override
    State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {

    final UserService _userService = UserService();
    final AuthService _authService = AuthService();

    late Future<UserModel> userInfo;

    @override
    void initState() {
        super.initState();
        userInfo = _fetchUserInfo();
    }

    Future<UserModel> _fetchUserInfo() async {
        return await _userService.userInfo();
    }

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
            body: futureUserModel(),
        );
    }

    futureUserModel() {
        return FutureBuilder<UserModel>(
            future: userInfo,
            builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                } else if(snapshot.hasError){
                    return const Center(child: Text('Error'));
                } else {
                    UserModel userInfo = snapshot.data!;
                    return profile(userInfo);
                }
            },
        );
    }

    profile(userInfo){
        return Center(
            child: Column(
                children: [
                    ListTile(
                        title: const Text('First Name', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(userInfo.data.email),
                    ),

                    ListTile(
                        title: const Text('Last Name', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(userInfo.data.email),
                    ),

                    ListTile(
                        title: const Text('Username', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(userInfo.data.email),
                    ),

                    ListTile(
                        title: const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(userInfo.data.email),
                    ),
                ],
            ),
        );
    }
}