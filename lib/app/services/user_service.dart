import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todolist_flutter/app/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {

    final storage = const FlutterSecureStorage();

    late String _apiUri;
    late String _apiUserInfo;


    Map<String, String> headers = {
        'Content-Type': 'application/json'
    };

    UserService(){
        _apiUri = dotenv.get('API_URL') + dotenv.get('API_VERSION');
        _apiUserInfo = '$_apiUri/user';
    }

    Future<UserModel> userInfo() async {
        var uri = Uri.parse(_apiUserInfo);
        var token = await storage.read(key: 'token');
        headers['Authorization'] = 'Bearer $token';
        var response = await http.get(uri, headers: headers);

        if(response.statusCode == 200){
            return UserModel.fromJson(json.decode(response.body));
        } else {
            throw Exception('Failed to load user info');
        }
    }
}