import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_flutter/app/services/auth_service.dart';

class CheckAuth extends StatelessWidget {
    const CheckAuth({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final authService = Provider.of<AuthService>(context, listen: false);
        
        return Scaffold(
            body: Center(
                child: FutureBuilder(
                    future: authService.getToken(), 
                    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {

                        if(snapshot.data == '' || snapshot.data == null){
                            Future.microtask(() {
                                Navigator.pushReplacementNamed(context, 'login');
                            });
                        } else {
                            Future.microtask(() {
                                Navigator.pushReplacementNamed(context, 'home');
                            });
                        }

                        return Container();
                    }
                )
            ),
        );
    }
}
