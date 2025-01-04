import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_flutter/app/interceptors/api_interceptor.dart';
import 'package:todolist_flutter/config/api.dart';

class AccountService {

    final String _apiUri;
    late String _apiUriAccount;

    final ApiInterceptor client = ApiInterceptor();

    AccountService(): _apiUri = apiUrlV1 {
        _apiUriAccount = '$_apiUri/account/profile';
    }

    updateProfile({required Map<String, String> data}) async {
        var uri = Uri.parse(_apiUriAccount);

        Response accountResponse = await client.patch(uri, body: json.encode(data));

        final Map<String, dynamic> responseBody = json.decode(accountResponse.body);

        if (accountResponse.statusCode == 200 && responseBody.containsKey('data')) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('user', json.encode(responseBody['data']['attributes']));
        }

        return responseBody;
    }
}
