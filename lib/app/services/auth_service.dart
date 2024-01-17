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

    Map<String, String> headers = {
        'Content-Type': 'application/json'
    };

    AuthService() {
        _apiUri = dotenv.get('API_URL') + dotenv.get('API_VERSION');
        _apiUriLogin = '$_apiUri/auth/login';
		_apiUriRegister = '$_apiUri/auth/register';
		_apiUriForgotPassword = '$_apiUri/auth/forgot-password';
		_apiUriLogout = '$_apiUri/auth/logout';
		_apiUriRefreshToken = '$_apiUri/auth/refresh-token';
    }

    login(Map<String, String> data) async {
        var uri = Uri.parse(_apiUriLogin);
        final response = await http.post(uri, body: json.encode(data), headers: headers);
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if(responseBody.containsKey('token')) {
            storage.write(key: 'token', value: responseBody['token']);
            storage.write(key: 'expires_at', value: responseBody['expires_at']);
        }

        return response;
    }

    register(data) async {
        var uri = Uri.parse(_apiUriRegister);
        var response = await http.post(uri, body: json.encode(data), headers: headers);
        return json.decode(response.body);
    }

    forgotPassword(data) async {
        var uri = Uri.parse(_apiUriForgotPassword);
        var response = await http.post(uri, body: json.encode(data), headers: headers);
        if(response.statusCode == 200) {
            return json.decode(response.body);
        } else {
            throw Exception('Unexpected response ${response.body}');
        }
    }

    Future<String?> logout() async {
        var uri = Uri.parse(_apiUriLogout);
        var token = await storage.read(key: 'token');
        headers['Authorization'] = 'Bearer $token';        
        var response = await http.post(uri, headers: headers);
        
        if(response.statusCode == 200) {
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

        if(token != null && expiresAt != null) {
            var now = DateTime.now();
            var expiresAtDate = DateTime.parse(expiresAt);

            if(now.isBefore(expiresAtDate)) {
                return true;
            }
        }

        return false;
    }

    Future<bool> isLoggedOut() async {
        return !(await isLoggedIn());
    }
}
