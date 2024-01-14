import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService extends ChangeNotifier{

    final storage = const FlutterSecureStorage();

	late String _apiUri;
    late String _apiUriLogin;
	late String _apiUriRegister;
	late String _apiUriForgotPassword;
	late String _apiUriLogout;
	late String _apiUriRefreshToken;

    AuthService() {
        _apiUri = dotenv.get('API_URL') + dotenv.get('API_VERSION');
        _apiUriLogin = '$_apiUri/auth/login';
		_apiUriRegister = '$_apiUri/auth/register';
		_apiUriForgotPassword = '$_apiUri/auth/forgot-password';
		_apiUriLogout = '$_apiUri/auth/logout';
		_apiUriRefreshToken = '$_apiUri/auth/refresh-token';
    }

    httpHeaders() => {
        'Content-Type': 'application/json'
    };

    login(Map<String, String> data) async {
        var uri = Uri.parse(_apiUriLogin);
        final response = await http.post(uri, body: jsonEncode(data), headers: httpHeaders());
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if(responseBody.containsKey('token')) {
            storage.write(key: 'token', value: responseBody['token']);
            storage.write(key: 'expires_at', value: responseBody['expires_at']);
        }

        return response;
    }

    register(data) async {
        var uri = Uri.parse(_apiUriRegister);
        return await http.post(uri, body: data, headers: httpHeaders());
    }

    forgotPassword(data) async {
        var uri = Uri.parse(_apiUriForgotPassword);
        return await http.post(uri, body: data, headers: httpHeaders());
    }

    logout() async {
        var uri = Uri.parse(_apiUriLogout);
        httpHeaders()['Authorization'] = 'Bearer ${dotenv.get('API_TOKEN')}';
        return await http.post(uri, headers: httpHeaders());
    }

    Future<String?> getToken() async {
        return await storage.read(key: 'token');
    }
}
