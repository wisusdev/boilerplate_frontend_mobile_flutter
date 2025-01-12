import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/interceptors/api_interceptor.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/api.dart';

class AccountService {

    final String _apiUri;
    late String _apiUriAccount;
    late String _apiUriChangePassword;

    final ApiInterceptor client = ApiInterceptor();

    AccountService(): _apiUri = apiUrlV1 {
        _apiUriAccount = '$_apiUri/account/profile';
        _apiUriChangePassword = '$_apiUri/account/change-password';
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

    changePassword({required Map<String, String> data}) async {
        var uri = Uri.parse(_apiUriChangePassword);

        Response accountResponse = await client.patch(uri, body: json.encode(data));

        final Map<String, dynamic> responseBody = json.decode(accountResponse.body);

        return responseBody;
    }
}
