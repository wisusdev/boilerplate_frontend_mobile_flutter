import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/http/interceptors/api_interceptor.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/api.dart';

class BaseService {

    final String _apiUri;
    late String _apiUriAccount;
    late String _apiUriChangePassword;
    late String _apiUriDeviceAuthList;
    late String _apiUriDeviceAuthDisconnect;
    late String _apiUriPermissions;
    late String _apiUriRoleIndex;
    late String _apiUriRoleCreate;
    late String _apiUriRoleUpdate;
    late String _apiUriRoleDelete;
    late String _apiUriUserIndex;
    late String _apiUriUserCreate;
    late String _apiUriUserUpdate;
    late String _apiUriUserDelete;
    late String _apiUriUserShow;

    final ApiInterceptor makeRequest = ApiInterceptor();

    BaseService(): _apiUri = apiUrlV1 {
        _apiUriAccount = '$_apiUri/account/profile';
        _apiUriChangePassword = '$_apiUri/account/change-password';
        _apiUriDeviceAuthList = '$_apiUri/account/devices-auth-list';
        _apiUriDeviceAuthDisconnect = '$_apiUri/account/logout-device';
        _apiUriPermissions = '$_apiUri/permissions';
        _apiUriRoleIndex = '$_apiUri/roles';
        _apiUriRoleCreate = '$_apiUri/roles';
        _apiUriRoleUpdate = '$_apiUri/roles';
        _apiUriRoleDelete = '$_apiUri/roles';
        _apiUriUserIndex = '$_apiUri/users';
        _apiUriUserCreate = '$_apiUri/users';
        _apiUriUserUpdate = '$_apiUri/users';
        _apiUriUserDelete = '$_apiUri/users';
        _apiUriUserShow = '$_apiUri/users';
    }

    updateProfile({required Map<String, String> data}) async {
        var uri = Uri.parse(_apiUriAccount);

        Response accountResponse = await makeRequest.patch(uri, body: json.encode(data));

        final Map<String, dynamic> responseBody = json.decode(accountResponse.body);

        if (accountResponse.statusCode == 200 && responseBody.containsKey('data')) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('user', json.encode(responseBody['data']['attributes']));
        }

        return responseBody;
    }

    changePassword({required Map<String, String> data}) async {
        var uri = Uri.parse(_apiUriChangePassword);

        Response accountResponse = await makeRequest.patch(uri, body: json.encode(data));

        final Map<String, dynamic> responseBody = json.decode(accountResponse.body);

        return responseBody;
    }

    getDeviceAuthList() async {
        Map<String, dynamic> params = {
            'fields[device_infos]': 'id,login_at,browser,os,ip,country',
            'page[number]': '1',
        };

        var uri = Uri.parse('$_apiUriDeviceAuthList?${Uri(queryParameters: params).query}');

        Response accountResponse = await makeRequest.get(uri);

        final Map<String, dynamic> responseBody = json.decode(accountResponse.body);

        Map<String, dynamic> response = {
            'response': responseBody,
            'statusCode': accountResponse.statusCode,
        };

        return response;
    }

    disconnectDevice({required Map<String, String> data}) async {
        var uri = Uri.parse(_apiUriDeviceAuthDisconnect);

        Response accountResponse = await makeRequest.post(uri, body: json.encode(data));

        final Map<String, dynamic> responseBody = json.decode(accountResponse.body);

        Map<String, dynamic> response = {
            'response': responseBody,
            'statusCode': accountResponse.statusCode,
        };

        return response;
    }

    getPermissions() async {
        var uri = Uri.parse(_apiUriPermissions);

        Response accountResponse = await makeRequest.get(uri);

        final Map<String, dynamic> responseBody = json.decode(accountResponse.body);
        
        Map<String, dynamic> response = {
            'response': responseBody,
            'statusCode': accountResponse.statusCode,
        };

        return response;
    }

    getRoleIndex() async {
        var uri = Uri.parse(_apiUriRoleIndex);

        Response accountResponse = await makeRequest.get(uri);

        final Map<String, dynamic> responseBody = json.decode(accountResponse.body);

        Map<String, dynamic> response = {
            'response': responseBody,
            'statusCode': accountResponse.statusCode,
        };

        return response;
    }

    createRole({required Map<String, dynamic> data}) async {
        var uri = Uri.parse(_apiUriRoleCreate);

        Response roleResponse = await makeRequest.post(uri, body: json.encode(data));

        final Map<String, dynamic> responseBody = json.decode(roleResponse.body);

        Map<String, dynamic> response = {
            'response': responseBody,
            'statusCode': roleResponse.statusCode,
        };

        return response;
    }

    updateRole({required String roleId, required Map<String, dynamic> data}) async {
        var uri = Uri.parse('$_apiUriRoleUpdate/$roleId');

        Response roleResponse = await makeRequest.patch(uri, body: json.encode(data));

        final Map<String, dynamic> responseBody = json.decode(roleResponse.body);

        Map<String, dynamic> response = {
            'response': responseBody,
            'statusCode': roleResponse.statusCode,
        };

        return response;
    }

    deleteRole({required String roleId}) async {
        var uri = Uri.parse('$_apiUriRoleDelete/$roleId');

        Response roleResponse = await makeRequest.delete(uri);

        return roleResponse.statusCode;
    }

    // User CRUD methods
    getUserIndex() async {
        var uri = Uri.parse(_apiUriUserIndex);

        Response userResponse = await makeRequest.get(uri);

        final Map<String, dynamic> responseBody = json.decode(userResponse.body);

        Map<String, dynamic> response = {
            'response': responseBody,
            'statusCode': userResponse.statusCode,
        };

        return response;
    }

    getUserShow({required String userId}) async {
        var uri = Uri.parse('$_apiUriUserShow/$userId');

        Response userResponse = await makeRequest.get(uri);

        final Map<String, dynamic> responseBody = json.decode(userResponse.body);

        Map<String, dynamic> response = {
            'response': responseBody,
            'statusCode': userResponse.statusCode,
        };

        return response;
    }

    createUser({required Map<String, dynamic> data}) async {
        var uri = Uri.parse(_apiUriUserCreate);

        Response userResponse = await makeRequest.post(uri, body: json.encode(data));

        final Map<String, dynamic> responseBody = json.decode(userResponse.body);

        Map<String, dynamic> response = {
            'response': responseBody,
            'statusCode': userResponse.statusCode,
        };

        return response;
    }

    updateUser({required String userId, required Map<String, dynamic> data}) async {
        var uri = Uri.parse('$_apiUriUserUpdate/$userId');

        Response userResponse = await makeRequest.patch(uri, body: json.encode(data));

        final Map<String, dynamic> responseBody = json.decode(userResponse.body);

        Map<String, dynamic> response = {
            'response': responseBody,
            'statusCode': userResponse.statusCode,
        };

        return response;
    }

    deleteUser({required String userId}) async {
        var uri = Uri.parse('$_apiUriUserDelete/$userId');

        Response userResponse = await makeRequest.delete(uri);

        return userResponse.statusCode;
    }
}
