import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiInterceptor extends http.BaseClient {

    final http.Client _httpClient = http.Client();

    @override
    Future<http.StreamedResponse> send(http.BaseRequest request) async {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('access_token');

        if (request is http.Request) {
            if (request.method == 'POST' || request.method == 'PATCH' || request.method == 'PUT') {

                if(request.body != '' && request.body.isNotEmpty){
                    var body = json.decode(request.body);

                    if(body['type'] == null){
                        throw Exception('The type field is required');
                    }
                    
                    var type = body['type'];
                    body.remove('type');

                    var data = {
                        'type': type,
                        'attributes': body,
                    };

                    if (request.method == 'PATCH' || request.method == 'PUT') {
                        if (body.containsKey('id')) {
                             data['id'] = body['id'];
                        } else {
                            throw Exception('The id field is required');
                        }
                    }

                    request.body = json.encode({'data': data});
                }
            }
        }

        request.headers['content-type'] = 'application/vnd.api+json';
        request.headers['accept'] = 'application/vnd.api+json';
        
        if (token != null) {
            request.headers['Authorization'] = 'Bearer $token';
        }

        return _httpClient.send(request);
    }
}
