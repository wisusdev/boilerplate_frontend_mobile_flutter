import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthService {

	late String _apiUri;
    late String _apiUriLogin;
	late String _apiUriRegister;
	late String _apiUriForgotPassword;
	late String _apiUriLogout;
	late String _apiUriRefreshToken;
    final isLoggeIn = false;

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
        return await http.post(uri, body: jsonEncode(data), headers: httpHeaders());
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
}
