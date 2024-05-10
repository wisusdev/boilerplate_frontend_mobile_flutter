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
        bool success = false;

        await client.post(uri, body: json.encode(data)).then((response) async {
            final Map<String, dynamic> responseBody = json.decode(response.body);
            if (response.statusCode == 200) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('user', json.encode(responseBody['data']['attributes']['user']));
                prefs.setString('permissions', json.encode(responseBody['data']['relationships']['permissions']));
                prefs.setString('user_key', responseBody['data']['id']);
                prefs.setString('access_token', responseBody['data']['relationships']['access']['token']);
                success = true;
            }
        });

    	return success;
  	}

  register(data) async {
    var uri = Uri.parse(_apiUriRegister);
    var response = await client.post(uri, body: json.encode(data));
    return json.decode(response.body);
  }

  forgotPassword(data) async {
    var uri = Uri.parse(_apiUriForgotPassword);
    var response = await client.post(uri, body: json.encode(data));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Unexpected response ${response.body}');
    }
  }

  Future<String?> logout() async {
    var uri = Uri.parse(_apiUriLogout);
    var response = await client.post(uri);

    if (response.statusCode == 200) {
      await storage.deleteAll();
    }

    return response.body;
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<String?> getExpiresAt() async {
    return await storage.read(key: 'expires_at');
  }

  Future<bool> isLoggedIn() async {
    var token = await getToken();
    var expiresAt = await getExpiresAt();

    if (token != null && expiresAt != null) {
      var now = DateTime.now();
      var expiresAtDate = DateTime.parse(expiresAt);

      if (now.isBefore(expiresAtDate)) {
        return true;
      }
    }

    return false;
  }

  Future<bool> isLoggedOut() async {
    return !(await isLoggedIn());
  }
}
