import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {

    Future<bool> isUserAuthenticated() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('access_token');

        if(token != null){
            return true;
        } else {
            return false;
        }
    }
}