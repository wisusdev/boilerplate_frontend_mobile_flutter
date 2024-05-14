import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_flutter/config/api.dart';
import 'package:todolist_flutter/app/interceptors/api_interceptor.dart';

class AuthService extends ChangeNotifier {
	final storage = const FlutterSecureStorage();

  	final String _apiUri;
  	late String _apiUriLogin;
  	late String _apiUriRegister;
  	late String _apiUriForgotPassword;
  	late String _apiUriLogout;

  	final ApiInterceptor client = ApiInterceptor();

  	AuthService() : _apiUri = apiUrlV1 {
    	_apiUriLogin = '$_apiUri/auth/login';
    	_apiUriLogout = '$_apiUri/auth/logout';
    	_apiUriRegister = '$_apiUri/auth/register';
    	_apiUriForgotPassword = '$_apiUri/auth/forgot-password';
  	}

    login({required Map<String, String> data}) async {
    	var uri = Uri.parse(_apiUriLogin);

        Map<String, dynamic> responseData = {};

        await client.post(uri, body: json.encode(data)).then((response) async {
            final Map<String, dynamic> responseBody = json.decode(response.body);
            
            if (response.statusCode == 200 && responseBody.containsKey('data')) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('user', json.encode(responseBody['data']['attributes']['user']));
                prefs.setString('permissions', json.encode(responseBody['data']['relationships']['permissions']));
                prefs.setString('user_key', responseBody['data']['id']);
                prefs.setString('access_token', responseBody['data']['relationships']['access']['token']);
            }
            
            responseData = responseBody;
        });

    	return responseData;
  	}

    register({required Map<String, String> data}) async {
        var uri = Uri.parse(_apiUriRegister);
        bool success = false;

        await client.post(uri, body: json.encode(data)).then((value) => {
            if (value.statusCode == 201) {
                success = true
            }
        });

        return success;
    }

    logout() async {
        var uri = Uri.parse(_apiUriLogout);
        bool success = false;

        await client.post(uri).then((response) async {
            if (response.statusCode == 200) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('user');
                prefs.remove('permissions');
                prefs.remove('user_key');
                prefs.remove('access_token');
                success = true;
            }
        });

        return success;
    }

    forgotPassword({required Map<String, String> data}) async {
        var uri = Uri.parse(_apiUriForgotPassword);
        bool success = false;
        
        await client.post(uri, body: json.encode(data)).then((value) => {
            if (value.statusCode == 200) {
                success = true
            }
        });

        return success;
    }
}
