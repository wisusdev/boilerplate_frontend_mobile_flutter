import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/interceptors/api_interceptor.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/api.dart';

class AccountService {

    final String _apiUri;
    late String _apiUriAccount;
    late String _apiUriChangePassword;
    late String _apiUriDeviceAuthList;
    late String _apiUriDeviceAuthDisconnect;

    final ApiInterceptor client = ApiInterceptor();

    AccountService(): _apiUri = apiUrlV1 {
        _apiUriAccount = '$_apiUri/account/profile';
        _apiUriChangePassword = '$_apiUri/account/change-password';
        _apiUriDeviceAuthList = '$_apiUri/account/devices-auth-list';
        _apiUriDeviceAuthDisconnect = '$_apiUri/account/logout-device';
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

    getDeviceAuthList() async {
        Map<String, dynamic> params = {
            'fields[device_infos]': 'id,login_at,browser,os,ip,country',
            'page[number]': '1',
        };

        var uri = Uri.parse('$_apiUriDeviceAuthList?${Uri(queryParameters: params).query}');

        Response accountResponse = await client.get(uri);

        final Map<String, dynamic> responseBody = json.decode(accountResponse.body);

        Map<String, dynamic> response = {
            'response': responseBody,
            'statusCode': accountResponse.statusCode,
        };

        return response;
    }

    disconnectDevice({required Map<String, String> data}) async {
        var uri = Uri.parse(_apiUriDeviceAuthDisconnect);

        Response accountResponse = await client.post(uri, body: json.encode(data));

        final Map<String, dynamic> responseBody = json.decode(accountResponse.body);

        Map<String, dynamic> response = {
            'response': responseBody,
            'statusCode': accountResponse.statusCode,
        };

        return response;
    }
}
