import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/auth_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/home.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

class AuthController {

    Future<void> login(context, loginData, Function setErrorMessages) async {

        Map<String, dynamic> loginResponse = await AuthService().login(data: loginData);

        if(loginResponse.containsKey('data')){
            Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => const HomeView()), 
                (route) => false
            );
        } 
        
        if(loginResponse.containsKey('errors')){
            var errors = loginResponse['errors'];

            Map<String, dynamic> errorMessage = {
                'email': null,
                'password': null,
            };

            if(errors is List){
                for (var error in errors) {
                    String title = error['title'];
                    List<String> titleList = title.split('.');

                    errorMessage[titleList.last] = Location.of(context)!.trans(error['detail']);
                }
            }

            setErrorMessages(errorMessage);
            toastDanger(context, Location.of(context)!.trans('errorAsOccurred'));
        }
    }
}