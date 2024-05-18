import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_flutter/config/api.dart';
import 'package:todolist_flutter/app/interceptors/api_interceptor.dart';

class AuthService extends ChangeNotifier {

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

        Response loginResponse = await client.post(uri, body: json.encode(data));

        final Map<String, dynamic> responseBody = json.decode(loginResponse.body);
        
        if (loginResponse.statusCode == 200 && responseBody.containsKey('data')) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('user', json.encode(responseBody['data']['attributes']['user']));
            prefs.setString('permissions', json.encode(responseBody['data']['relationships']['permissions']));
            prefs.setString('user_key', responseBody['data']['id']);
            prefs.setString('access_token', responseBody['data']['relationships']['access']['token']);
        }
        
        return responseBody;
  	}

    register({required Map<String, String> data}) async {
        var uri = Uri.parse(_apiUriRegister);

        Response registerResponse = await client.post(uri, body: json.encode(data));
        final Map<String, dynamic> responseBody = json.decode(registerResponse.body);
        
        return responseBody;
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
        
        Response forgotPasswordResponse = await client.post(uri, body: json.encode(data));
        final Map<String, dynamic> responseBody = json.decode(forgotPasswordResponse.body);

        return responseBody;
    }
}
